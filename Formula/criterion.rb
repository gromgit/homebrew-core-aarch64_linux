class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"
  url "https://github.com/Snaipe/Criterion/releases/download/v2.4.1/criterion-2.4.1.tar.xz"
  sha256 "d0f86a8fc868e2c7b83894ad058313023176d406501a4ee8863e5357e31a80e7"
  license "MIT"
  head "https://github.com/Snaipe/Criterion.git", branch: "bleeding"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/criterion"
    sha256 aarch64_linux: "c283cbacd50da667135904658f961ceedcb80b865c1610eb285f9ce05b30a364"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libgit2"
  depends_on "nanomsg"
  uses_from_macos "libffi"

  def install
    system "meson", "setup", *std_meson_args, "--force-fallback-for=boxfort", "build"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "--skip-subprojects", "-C", "build"
  end

  test do
    (testpath/"test-criterion.c").write <<~EOS
      #include <criterion/criterion.h>

      Test(suite_name, test_name)
      {
        cr_assert(1);
      }
    EOS

    system ENV.cc, "test-criterion.c", "-I#{include}", "-L#{lib}", "-lcriterion", "-o", "test-criterion"
    system "./test-criterion"
  end
end
