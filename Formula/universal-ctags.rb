class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220911.0.tar.gz"
  version "p5.9.20220911.0"
  sha256 "850b0e2f3d72cef5d962d90328e7463ee8fc49c19a7816fe26b1328f9334b27f"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "39d5f72769c6b064c865168b3f85f97c62b0e6db5e6cff28e56342b80f663afe"
    sha256 cellar: :any,                 arm64_big_sur:  "e344f2196583a5213d58dd3d76eb6963dac826d220ecc1bada1676ded0a03bba"
    sha256 cellar: :any,                 monterey:       "4882fb729672e438c0b9b9a9cd9bcf172f547e2771c73fa6ac07955edf0b5b1f"
    sha256 cellar: :any,                 big_sur:        "7e16bbe783c61b1dd188d7daacf4689e29c85ff71dd88752cb6802d2ec6c8ec4"
    sha256 cellar: :any,                 catalina:       "edd3020f0ddb8cd34058545541de576c0de96eff35b7fbb269b08e8d2ef7c7e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25721e22838183edb95050b7c64644415d5217f3e138e357e001961e61e4c851"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libyaml"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "this formula installs the same executable as the ctags formula"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    EOS
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end
