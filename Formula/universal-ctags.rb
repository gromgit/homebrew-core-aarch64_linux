class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220501.0.tar.gz"
  version "p5.9.20220501.0"
  sha256 "5b21aa399cf017fb89cfe6bc2dbbcac8d57f334f649ea51bf776c96f195fb822"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cca5e5ec13d329b0b0e4c3e76f228bcd6326638426740b673d514af8f79cb85b"
    sha256 cellar: :any,                 arm64_big_sur:  "44382d6b0509beefe8686d95e97852ca569e96162a862ee444a7f96d6e24995f"
    sha256 cellar: :any,                 monterey:       "b3d2115278abbf04e5fd6026454da7b5f75dc7b518f14c3d348fe9f86aa8ec30"
    sha256 cellar: :any,                 big_sur:        "14ac4beb52cc3a497b38ba9dbaddcc72723d4e1f6dbc83d46b94fa8650ce2f9f"
    sha256 cellar: :any,                 catalina:       "3ccfa399c137a4c630a57a8e1e4e82a7f5f3a48712f51d03209fa5f99a50528d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad22349f64f577a711e022c2460160b29ab2b2aa5cb4b6bc078e329e64f299b7"
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
