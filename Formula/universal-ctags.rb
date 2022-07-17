class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220717.0.tar.gz"
  version "p5.9.20220717.0"
  sha256 "4f6e9191f2f74cb8adf50da72ce12513a53835aace3bd68579c1d16fcf233275"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e905763e267786ee803954d665c98b61f16bacfaf7cb86ce897267fcfff34155"
    sha256 cellar: :any,                 arm64_big_sur:  "41b31345cb3f23578c4e3747e65992c64d4c0da2a21ab4fb4b3da907d38c08bd"
    sha256 cellar: :any,                 monterey:       "7ec527e848d6dcf43e6ababab2e1996cbdff81e7e8e4ae5709273e04ec0deef7"
    sha256 cellar: :any,                 big_sur:        "bbac2b251dc0cac1d58e72d9274978a43f579572f861fe656ebf4bc062373988"
    sha256 cellar: :any,                 catalina:       "a45655e1bdc482647643407741b03fca1f6044b73d30e5c70ec19ed24d41e66f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a6279867e516828e979d0c8a49a23dad7e87abd2407f6be4e446cda133e8e63"
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
