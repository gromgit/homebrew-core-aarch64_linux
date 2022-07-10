class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220710.0.tar.gz"
  version "p5.9.20220710.0"
  sha256 "6206ac12512c13f62ff6995b7188081d383f233b2122e6900040bd5e2164cd89"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a00edc4d40390631aa3393d2794e222debb6ffde7a33b9281f777c8dc9bffe57"
    sha256 cellar: :any,                 arm64_big_sur:  "95647819b9cafe6082dbc7d63cb4447c009ddc77fb1cc9e569a4a567dc6d7a71"
    sha256 cellar: :any,                 monterey:       "f2f53d4fcddaf5f0c50b5dfb92fd727f7ee8692a405d88ed7422430145cbc208"
    sha256 cellar: :any,                 big_sur:        "e6aa066ffa0141b2cced8882ffd64de96425dc83b81cba54038a416034aadb08"
    sha256 cellar: :any,                 catalina:       "5db90d808ca0d5dc522162b88aaa0ea8765b8be5557ca4da9c14571f568ac95a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bfb115a0f8c878417b6a295f64eaa356a42089195f4dd48168460e8ac2ad045"
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
