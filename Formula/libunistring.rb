class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftp.gnu.org/gnu/libunistring/libunistring-1.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libunistring/libunistring-1.0.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libunistring/libunistring-1.0.tar.gz"
  sha256 "3c0184c0e492d7c208ce31d25dd1d2c58f0c3ed6cbbe032c5b248cddad318544"
  license any_of: ["GPL-2.0-only", "LGPL-3.0-or-later"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libunistring"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3212fe71edf68435ea74b977d3215507e3d965a01c65078ac316561b4bae1ce0"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uniname.h>
      #include <unistdio.h>
      #include <unistr.h>
      #include <stdlib.h>
      int main (void) {
        uint32_t s[2] = {};
        uint8_t buff[12] = {};
        if (u32_uctomb (s, unicode_name_character ("BEER MUG"), sizeof s) != 1) abort();
        if (u8_sprintf (buff, "%llU", s) != 4) abort();
        printf ("%s\\n", buff);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lunistring",
                   "-o", "test"
    assert_equal "🍺", shell_output("./test").chomp
  end
end
