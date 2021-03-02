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
    sha256 arm64_big_sur: "2597b3ba0c568ed03b04abf4efe934a1605de3c2c1191fd455aa8cacf7dd14a9"
    sha256 big_sur:       "2d6b9bf3240a9f942f6bd19e68063bbaa362ebde36e5fd366c86754d81e3167c"
    sha256 catalina:      "3adaabf47068a95e705f81b591d7925b6d44c051db1861c53c76901bde44475c"
    sha256 mojave:        "1439d26ec6d62bfe1da89457eb782c2ef1b4b1a2d6a9de99dee9ae3c5bce290c"
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
