class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/"
  url "https://www.aquamaniac.de/rdm/attachments/download/348/gwenhywfar-5.5.0.tar.gz"
  sha256 "c625621f8a6500a4a94a364a24fed74651d3a5300f8437e0c02f9072a84cf8c0"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/gwenhywfar/files"
    regex(/href=.*?gwenhywfar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "f5bd300b1c96afe06fd343e306159bd9ae571be1602a35175f92d8ffd55175d1"
    sha256 big_sur:       "2c90838bfd5ad9a2974b7f5be85e67e5c57033d3e36c9bdd0c8a9b175293a52f"
    sha256 catalina:      "9d06563f886f4abd54fc5ee792cf3d455087714e0e30bc3d3b76d6297c33a986"
    sha256 mojave:        "86fd5ee0468a467e7a09357bd68f8c3a47f8bfc700cf3a31b7730d38c72045ef"
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
