class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220814.0.tar.gz"
  version "p5.9.20220814.0"
  sha256 "6f912726483ba57e1c80468fccd1329a1b40ba03cd5630529bbe09497902a7ef"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ada9835650bb1712726716404bf56814aed949fa9d094d6a011b9f64a8fafa31"
    sha256 cellar: :any,                 arm64_big_sur:  "2ba24b7b752280647fda03ced2eac70e5706f8b2f0cb8416b990bb09e75bf53f"
    sha256 cellar: :any,                 monterey:       "31fe01f64d6cf41d8b28c9aa4a5bb3902cafead3552916dc16bdfce3073a03f2"
    sha256 cellar: :any,                 big_sur:        "64412069e798519f0a62a8b140e1aece4625004a92efc9e052f06502e58dd32a"
    sha256 cellar: :any,                 catalina:       "e83e609e91eb15466b70bb7e45fb105c3462e5bf348db2f421846c7032efefd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eed304c26a697eaee5ac8e7a6027428888b812c787f566df4f514f4da0035ed9"
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
