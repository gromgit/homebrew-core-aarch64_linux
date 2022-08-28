class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220828.0.tar.gz"
  version "p5.9.20220828.0"
  sha256 "4db81bb98b4549af5128d5c2a53da8a17e3e4fdaa3345f8aee5d4d258c6f2956"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a9675ee16d90813460fb176b930ed8da423fe53283103379a88fc3d73cc7423c"
    sha256 cellar: :any,                 arm64_big_sur:  "3748b0af2818e4259293db93bedb225464126a53ce118a01c1bb4478f05b83d9"
    sha256 cellar: :any,                 monterey:       "49a4e54d5de0d2371287728653ca1ba46d8c5e5288b99da64df6948ffc67fd25"
    sha256 cellar: :any,                 big_sur:        "e2e00678e848acb7816a7853c98919f84f91e61a92305d481afbe43d39a92a98"
    sha256 cellar: :any,                 catalina:       "b6773ee4fdb5261916afc32967e86098953b1b2a406884a4ae53f7f56659a2ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e831da0a72d71d48e3c209a623ea19b6693102370050519c7a85e70f3946517"
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
