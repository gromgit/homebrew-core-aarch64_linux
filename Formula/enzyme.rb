class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.43.tar.gz", using: :homebrew_curl
  sha256 "42e375c3df0444e8f3abf0322a10f5183f2af5d9d459de44d83fbd93cd74675a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "41183c48d17acbc0f68bc10f57d42aabba58865633aa3a523e94be4e56ae2d5e"
    sha256 cellar: :any,                 arm64_big_sur:  "00f96505cfd7e99fa662adf8c5aec3b3a60492e7593c0730c9f12ab51aed361a"
    sha256 cellar: :any,                 monterey:       "8ad11c83631b50924657f9d43091d216970a120b91a8b0c5b2668d3af5a6070c"
    sha256 cellar: :any,                 big_sur:        "5342888c83795a4d1051d62ee5b0a0b57e0e1d1f937859892236de0f1c5faf99"
    sha256 cellar: :any,                 catalina:       "8e03b107562943593516fb8bb49c07d064bf91675c6e66d0f56aad86e8ab7d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "715427e962eeaeb901189b3cb5a72f569d9708c3389ec49ae58873cff8bd58ae"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      extern double __enzyme_autodiff(void*, double);
      double square(double x) {
        return x * x;
      }
      double dsquare(double x) {
        return __enzyme_autodiff(square, x);
      }
      int main() {
        double i = 21.0;
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    EOS

    opt = llvm.opt_bin/"opt"
    ENV["CC"] = llvm.opt_bin/"clang"

    # `-Xclang -no-opaque-pointers` is a transitional flag for LLVM 15, and will
    # likely be need to removed in LLVM 16. See:
    # https://llvm.org/docs/OpaquePointers.html#version-support
    system ENV.cc, "-v", testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops",
                   "-Xclang", "-no-opaque-pointers"
    system opt, "input.ll", "--enable-new-pm=0",
                "-load=#{opt_lib/shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "--enzyme-attributor=0", "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
