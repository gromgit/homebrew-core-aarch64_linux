class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220515.0.tar.gz"
  version "p5.9.20220515.0"
  sha256 "0f6de6f2434290304187d03b9816e1a2a322f922d124264f71e0ef7e07e7970c"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a549be2ca2950419ac4e8f14981880021d32d35f8bd7e6cdac94bba5b86a9bed"
    sha256 cellar: :any,                 arm64_big_sur:  "005fca56d1a64287839ca9373310b6030ec0f51f2d533fd6666ac2327579d351"
    sha256 cellar: :any,                 monterey:       "e96af38200a8a5ed81fd1191235dd93aae664f82535d10c75cefae1358092036"
    sha256 cellar: :any,                 big_sur:        "4f676621b0b85b480406ba66a5122ac73558c63befe4a53f9a93b2ab2183dd78"
    sha256 cellar: :any,                 catalina:       "ef70f3290ec55c9190b32802e1264e7df84f6d2de8bbc0a9f27e13cadd156c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1815ae16aaa0cdf72b74313f98579a42c77da69d4559f7be978a4935a2f75c30"
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
