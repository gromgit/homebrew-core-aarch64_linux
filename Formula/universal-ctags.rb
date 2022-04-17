class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220417.0.tar.gz"
  version "p5.9.20220417.0"
  sha256 "0871ab2a38b7d8e09e387765a4de69ef93b00a951ca976a4269b34008b871c01"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "29d806c155082e52afe19559d60d39c0bb1009dc9c30617ea9ec29baa4458649"
    sha256 cellar: :any,                 arm64_big_sur:  "cfe32c33546db0aa961179b47372fe2e823309e1bc00d41dec4c42eae9408d48"
    sha256 cellar: :any,                 monterey:       "9a90e9295747c015da0c9213fad489f1b8a1d5d47debcbcc6e4c7ee3f6b94c4b"
    sha256 cellar: :any,                 big_sur:        "9ac837efc84c4fdebe64b5eb9995706f058908a40189148b4d7d6aa481f87e97"
    sha256 cellar: :any,                 catalina:       "b7455adb2ecb2bc4ed50479baa2ef0af14093cfcaa2d1f24abc974dcb9cda109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a60979543cb6b68ad7cf0de27b32ce3e368941757dd817baec41f8f14a8af0b"
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
