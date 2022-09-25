class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220925.0.tar.gz"
  version "p5.9.20220925.0"
  sha256 "f804d3ea2aad27e0debaef7ed4914a354383bbf4ff74e86344987864809032f1"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "57ce677f4792d494b436ede050ce3580ebd367f6f82ee2e2c7b1bb5802f3d626"
    sha256 cellar: :any,                 arm64_big_sur:  "bf12bd4930d5995a1f31c627207b53ceca485ec36f2ba675754c67878f1c5919"
    sha256 cellar: :any,                 monterey:       "0a0960646dadabd0dac43f19f9727dec28ff957a0bbb87f1fdfef39e9accdd42"
    sha256 cellar: :any,                 big_sur:        "429e833fbc783b902ce64d8aada6fdc46f26de7ff6416c79959d53c78917f364"
    sha256 cellar: :any,                 catalina:       "7ac58d331a0aa07ee182382dd4697e9129ba2d2d0fe9fcefaf291266bb13fd9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "597ead58bd3af6e0e8ca784fc2452301133d1968ed2b24de27d72f47be358392"
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
