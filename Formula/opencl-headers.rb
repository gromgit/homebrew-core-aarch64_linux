class OpenclHeaders < Formula
  desc "C language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-Headers/archive/refs/tags/v2022.05.18.tar.gz"
  sha256 "88a1177853b279eaf574e2aafad26a84be1a6f615ab1b00c20d5af2ace95c42e"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-Headers.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/opencl-headers"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1a014e5a97f25ae5432c9b37f1bb7ad1165f1b4b22751640c5ff65a0b07799de"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenCL.framework"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <CL/opencl.h>

      int main(void) {
        printf("opencl.h standalone test PASSED.");
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}"
    assert_equal "opencl.h standalone test PASSED.", shell_output("./test")
  end
end
