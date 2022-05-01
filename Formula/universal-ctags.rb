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
    sha256 cellar: :any,                 arm64_monterey: "4525ab5ea72539b24483df1ce1c462e46ded785ea15306d59ba61ee29301c924"
    sha256 cellar: :any,                 arm64_big_sur:  "ac1dcd755192de499ae3ce4d9ce1c9e61c4b9544b334fce56e40847f1bacd517"
    sha256 cellar: :any,                 monterey:       "1dae0e032cbea642e72f17db57f423b2ecb53f6084642ea3960387fc5d2b3978"
    sha256 cellar: :any,                 big_sur:        "bd338deb81e3dfbf28dc344f9d987b135be1f7b2fd616e12dccaae484acd632e"
    sha256 cellar: :any,                 catalina:       "5dd7c98ca4c1f98970e13687666b0e73200f4745175c04703ee2a9a17a97be6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "357c415aade04d0d3424c085753ce3e20c7909aa53c2858c9ac3d2305804db1b"
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
