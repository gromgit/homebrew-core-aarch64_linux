class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20210829.0.tar.gz"
  version "p5.9.20210829.0"
  sha256 "7c25e9ea2c478185610656cbccdbe322b9d1503da07e94a23be96b4f2e6176c5"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d602fa39b10695d0144c44bd1cab837084e95aa4b9a465619e486c64351454b5"
    sha256 cellar: :any,                 big_sur:       "94eb54318ec91f9d8057e476e084d8b75a24c8af9299149588d12d6080b10273"
    sha256 cellar: :any,                 catalina:      "469b0df88ef65474cc589c3191968c43edf74de02a2f0e1494bbe7d47b406cbe"
    sha256 cellar: :any,                 mojave:        "d03740db19f1f94e75f16359c697438f099194e3a8cd85bc9a2a6d3ffd56faf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91f9f1dd99cd54d2602d46cc1e7c0dab5dc64db9e92d75c6ff67b073b2351494"
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
