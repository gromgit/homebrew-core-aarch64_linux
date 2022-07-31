class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220731.0.tar.gz"
  version "p5.9.20220731.0"
  sha256 "0ba7415586107afc7793e3425df068a22748c09df5a184fd8b81b83f55968337"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c19027e79112e0f84062b58406282d1273c4a6065c642c71d7b22561d95fe630"
    sha256 cellar: :any,                 arm64_big_sur:  "0f2fdce5c2b00605faab14ad33345edcfd01803db4487aeb5611bb886e42acbc"
    sha256 cellar: :any,                 monterey:       "f754bf412e0c5c2b8196cad015287004ec180aba747324cbfd2891a248e877ff"
    sha256 cellar: :any,                 big_sur:        "d70ba9887a6106e3cb83cdb7db47ffb9f562f4a46ccf459cdff03480e442c004"
    sha256 cellar: :any,                 catalina:       "b55cd00ff45430ef7d05b6e0f0767b983047487d7d723efb06eef3bf3b45aee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61420bcb52bddfda3dd7b0e6d95abd79596763567369340f265cbef44e38fb53"
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
