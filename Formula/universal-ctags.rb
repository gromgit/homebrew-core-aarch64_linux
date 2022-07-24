class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220724.0.tar.gz"
  version "p5.9.20220724.0"
  sha256 "231fb5d76ee6d5c86448bef6f3c77184c67fa7fe49b63efd4da34c16b3f13654"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "85e9879ab94c8c0de85b7924f56f4ef89d026cd2905d2e67c6c8b8f3ccff4b6e"
    sha256 cellar: :any,                 arm64_big_sur:  "006d86b9ffe49a4b4fef4c38ddc4f2abb607824b01428bcc7cf080f86fae4133"
    sha256 cellar: :any,                 monterey:       "8edb81a4b16b8080155113bb655ae2c23168df5d94faf6dff3a368b7dad34fd9"
    sha256 cellar: :any,                 big_sur:        "6c7b03a723996233de5a31a5a1fe65a64326e34a79bde17ed8891099b649073c"
    sha256 cellar: :any,                 catalina:       "a89028fb88663efe1c1168e30bfcae364e8dbeeb58ea564e5f2ba7ef89dc44da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cf9a4961cd840852b997ed917fc80edac766b02720f3bd425d8084a8bcdb5f2"
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
