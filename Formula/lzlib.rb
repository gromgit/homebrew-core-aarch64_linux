class Lzlib < Formula
  desc "Data compression library"
  homepage "https://www.nongnu.org/lzip/lzlib.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.12.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.12.tar.gz"
  sha256 "8e5d84242eb52cf1dcc98e58bd9ba8ef1aefa501431abdd0273a22bf4ce337b1"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lzlib/"
    regex(/href=.*?lzlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3123446096a5f2ddc9375ff536ed3bb2add4ff2529910033f7e4b6a30a0e76b9" => :big_sur
    sha256 "9e8ce7938f1cb1bd52c3282041d731f08f724be1db85abb31b98c9dc9ac094cf" => :arm64_big_sur
    sha256 "8d43e434cb121e5fd9c1be9adfc0ff6c8afa8f51c786a5b855117eb6f3e9e2dd" => :catalina
    sha256 "3c28dea3721b03227d660c7c453673d3cb40f00f41e2e4ba3f163a7171926da0" => :mojave
    sha256 "a49b8dfcf257d31c46841a733f1925020dd49493554d049a479467e602e3e796" => :high_sierra
    sha256 "3c6df94a873fc2268478e10c23d1aa631c6b29e1afff38de63e2839ad0f1968c" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdint.h>
      #include "lzlib.h"
      int main (void) {
        printf ("%s", LZ_version());
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-llz",
                   "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
