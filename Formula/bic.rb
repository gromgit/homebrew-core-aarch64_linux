class Bic < Formula
  desc "C interpreter and API explorer"
  homepage "https://github.com/hexagonal-sun/bic"
  url "https://github.com/hexagonal-sun/bic/releases/download/v1.0.0/bic-v1.0.0.tar.gz"
  sha256 "553324e39d87df59930d093a264c14176d5e3aaa24cd8bff276531fb94775100"
  head do
    url "https://github.com/hexagonal-sun/bic.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build # macOS bison is too outdated, build fails unless gnu bison is used
    depends_on "libtool" => :build if build.head?

    uses_from_macos "flex" => :build
  end

  depends_on "gmp"
  uses_from_macos "readline"

  def install
    system "autoreconf", "-fi" if build.head?
    system "./configure", "--disable-debug",
           "--disable-dependency-tracking",
          "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main () {
        puts("Hello Homebrew!");
      }
    EOS
    assert_equal "Hello Homebrew!", shell_output("#{bin}/bic -s hello.c").strip
  end
end
