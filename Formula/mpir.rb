class Mpir < Formula
  desc "Multiple Precision Integers and Rationals (fork of GMP)"
  homepage "https://mpir.org/"
  url "https://mpir.org/mpir-3.0.0.tar.bz2"
  sha256 "52f63459cf3f9478859de29e00357f004050ead70b45913f2c2269d9708675bb"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d45de304310770a0788c528faff83b5c16ad8903f54e7788fcb5b0d16182d049" => :catalina
    sha256 "5fd2ec4df58a2c8a1dd74729c90dd6928893f9c87c8ee06af8519dfb7ea9d71f" => :mojave
    sha256 "e9786b8cd2ee485e34b6e63c95bb7f71289c038dc9be0fdf583279853056302a" => :high_sierra
    sha256 "006955801271b94f2e412ac056450000785965ed631d134554d7190deaf675d1" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "yasm" => :build

  # Fix Xcode 12 build: https://github.com/wbhart/mpir/pull/292
  patch do
    url "https://github.com/wbhart/mpir/commit/bbc43ca6ae0bec4f64e69c9cd4c967005d6470eb.patch?full_index=1"
    sha256 "8c0ec267c62a91fe6c21d43467fee736fb5431bd9e604dc930cc71048f4e3452"
  end

  def install
    # Regenerate ./configure script due to patch above
    system "autoreconf", "--verbose", "--install", "--force"
    args = %W[--disable-silent-rules --prefix=#{prefix} --enable-cxx]
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpir.h>
      #include <stdlib.h>

      int main() {
        mpz_t i, j, k;
        mpz_init_set_str (i, "1a", 16);
        mpz_init (j);
        mpz_init (k);
        mpz_sqrtrem (j, k, i);
        if (mpz_get_si (j) != 5 || mpz_get_si (k) != 1) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmpir", "-o", "test"
    system "./test"
  end
end
