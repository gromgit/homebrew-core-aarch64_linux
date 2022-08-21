class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220821.0.tar.gz"
  version "p5.9.20220821.0"
  sha256 "2dfb2803ada53f4f710947687266e132eadf1b3c2fe1c94269c7c5bde6b69dc8"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "89db03aa9bedaad85c853fd057e836fb64ccfedb16f42718667f914d63ce748e"
    sha256 cellar: :any,                 arm64_big_sur:  "8d45f0b5bb41ccae97721c78861731878c2d9c21c6a6970bdd84c9d8ae796a05"
    sha256 cellar: :any,                 monterey:       "1be497928b872352ed37a6728fff7f18c7be050f13078abb08c838106100b07e"
    sha256 cellar: :any,                 big_sur:        "997035267e5e336077fe16e123622b84044510fd18ec7458664584d266d5e4a1"
    sha256 cellar: :any,                 catalina:       "1d1c054c424c2588abb2a32d3a7887b1a8959513ca487fadeb6de35fbfc77c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d36f4926d6f16bd3e20d26e1e6f4474ece9ff3e7a5bacaf86601d111b2e92d9"
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
