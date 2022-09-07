class Bic < Formula
  desc "C interpreter and API explorer"
  homepage "https://github.com/hexagonal-sun/bic"
  url "https://github.com/hexagonal-sun/bic/releases/download/v1.0.0/bic-v1.0.0.tar.gz"
  sha256 "553324e39d87df59930d093a264c14176d5e3aaa24cd8bff276531fb94775100"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bic"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c9f1c2d9d8341b468f5ee9299d470f00ba653d0d70cf0bb34d94a2a84620c48b"
  end

  head do
    url "https://github.com/hexagonal-sun/bic.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build # macOS bison is too outdated, build fails unless gnu bison is used
    depends_on "libtool" => :build

    uses_from_macos "flex" => :build
  end

  depends_on "gmp"

  on_linux do
    depends_on "readline"
  end

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
