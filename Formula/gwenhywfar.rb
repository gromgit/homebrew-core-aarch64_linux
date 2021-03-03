class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/"
  url "https://www.aquamaniac.de/rdm/attachments/download/364/gwenhywfar-5.6.0.tar.gz"
  sha256 "57af46920991290372752164f9a7518b222f99bca2ef39c77deab57d14914bc7"
  license "LGPL-2.1-or-later"

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

  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "openssl@1.1"
  depends_on "pkg-config" # gwenhywfar-config needs pkg-config for execution

  def install
    inreplace "gwenhywfar-config.in.in", "@PKG_CONFIG@", "pkg-config"
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-guis=cocoa"
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
    system ENV.cc, "test.c", "-I#{include}/gwenhywfar5", "-L#{lib}", "-lgwenhywfar", "-o", "test"
    system "./test"
  end
end
