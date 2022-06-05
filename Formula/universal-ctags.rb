class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220605.0.tar.gz"
  version "p5.9.20220605.0"
  sha256 "72b88dd241cc4c7ff1f052b155b9c21d9136d69d9932e976409979d739f522ce"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8977d9ad6966090c2035d0e2545bbb20a2afd826022b5d1748044675754ad03f"
    sha256 cellar: :any,                 arm64_big_sur:  "51945fd12abb27d83db6441b101fbc008f0c9b47f156dfa6b23b03e804b0f5dc"
    sha256 cellar: :any,                 monterey:       "9a38efb11937b5dd183785fee32cf1ce26117a3be32905fe79b27ea9c60c9c6d"
    sha256 cellar: :any,                 big_sur:        "ae7a1f8950a333e360b36d1434c6fffbdba01bb32c71789619a12eeaaadd654e"
    sha256 cellar: :any,                 catalina:       "4c078fee3ba9f1f64925e846eaa1e7ed6e09a54e5fecabfaecb2e23cbf274cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d7c7e3828b3761e836d9b705b710ef193c580280ad940d9398d116faf1c19b3"
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
