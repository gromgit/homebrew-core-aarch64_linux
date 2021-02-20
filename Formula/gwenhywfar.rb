class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/"
  url "https://www.aquamaniac.de/rdm/attachments/download/364/gwenhywfar-5.6.0.tar.gz"
  sha256 "57af46920991290372752164f9a7518b222f99bca2ef39c77deab57d14914bc7"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/gwenhywfar/files"
    regex(/href=.*?gwenhywfar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "f70cf20a97f43e19eede3af878da91f23fd44b6e60d7e14de80a7a1ffaffa10d"
    sha256 big_sur:       "baaf15c57cdcf69669b09bb5413cfdbb97232b6707d3091ec71f9f573c495a99"
    sha256 catalina:      "b1d5dfe78e11d6e4fa221d7d4d22eab385ed4763583fe68895e3106ae5703436"
    sha256 mojave:        "d33d0fcd0524fcdbf99150eb23dbf0f0482fa47294b24b0f2985c0d27e2a10a2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :test
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "openssl@1.1"
  depends_on "pkg-config" # gwenhywfar-config needs pkg-config for execution
  depends_on "qt@5"

  patch do # fixes out-of-tree builds, can be removed with 5.6.1+ release. https://www.aquamaniac.de/rdm/issues/232
    url "https://www.aquamaniac.de/rdm/projects/gwenhywfar/repository/revisions/b953672c5f668c2ed3960607e6e25651a2cc98db/diff/m4/ax_have_qt.m4?format=diff"
    sha256 "da7c1ddce2b8d1f19293d43b0db8449a4e45b79801101e866aa42f212f750ecd"
  end

  def install
    inreplace "gwenhywfar-config.in.in", "@PKG_CONFIG@", "pkg-config"
    system "autoreconf", "-fiv" # needed because of the patch. Otherwise only needed for head build (if build.head?)
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-guis=cocoa cpp qt5"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gwenhywfar/gwenhywfar.h>

      int main()
      {
        GWEN_Init();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/gwenhywfar5", "-L#{lib}", "-lgwenhywfar", "-o", "test_c"
    system "./test_c"

    system ENV.cxx, "test.c", "-I#{include}/gwenhywfar5", "-L#{lib}", "-lgwenhywfar", "-o", "test_cpp"
    system "./test_cpp"

    (testpath/"CMakeLists.txt").write <<~EOS
      project(test_gwen)

      find_package(Qt5 REQUIRED Core Widgets)
      find_package(gwenhywfar REQUIRED)
      find_package(gwengui-cpp REQUIRED)
      find_package(gwengui-qt5 REQUIRED)

      add_executable(${PROJECT_NAME} test.c)

      target_link_libraries(${PROJECT_NAME} PUBLIC
                      gwenhywfar::core
                      gwenhywfar::gui-cpp
                      gwenhywfar::gui-qt5
      )
    EOS

    args = std_cmake_args
    args << "-DQt5_DIR=#{Formula["qt@5"].opt_prefix/"lib/cmake/Qt5"}"

    system "cmake", testpath.to_s, *args
    system "make"
  end
end
