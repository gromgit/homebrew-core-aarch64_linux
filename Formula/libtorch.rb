class Libtorch < Formula
  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch.git",
      tag:      "v1.12.1",
      revision: "664058fa83f1d8eede5d66418abff6e20bd76ca8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "5e16e47a6006e86190a245820fafbefef2829478818d61b0d6dc9b851f729d78"
    sha256 cellar: :any,                 arm64_big_sur:  "4d49131eeb1e403521fcf04833b004a0af997381a54d018047776fe9b3f7dfc7"
    sha256 cellar: :any,                 monterey:       "30fca833944f65f0d7c1df6170bbcbdda67623054acc6b99714a38766c9bf975"
    sha256 cellar: :any,                 big_sur:        "a86aeb431832568ebcf214fbf7d08e96cec8a11eabb07c1e125db1ad48089a95"
    sha256 cellar: :any,                 catalina:       "ec36245f5f4274950e000d6a998af57ce93e3357a797ea143d50d5a399e2f270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbcffba1dbf409906cc77a2d1889e9ee656a46065dbdb1896f7ff12ca8749a93"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "eigen"
  depends_on "libuv"
  depends_on "openblas"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "pybind11"
  depends_on "python-typing-extensions"
  depends_on "pyyaml"

  on_macos do
    depends_on "libomp"
  end

  # Update fbgemm to a version that works with macOS on Intel.
  # Remove with next release.
  resource "fbgemm" do
    url "https://github.com/pytorch/FBGEMM.git",
    revision: "0d98c261561524cce92e37fe307ea6596664309a"
  end

  def install
    rm_r "third_party/fbgemm"

    resource("fbgemm").stage(buildpath/"third_party/fbgemm")

    openssl_root = Formula["openssl@1.1"].opt_prefix
    args = %W[
      -DBLAS=OpenBLAS
      -DBUILD_CUSTOM_PROTOBUF=OFF
      -DBUILD_PYTHON=OFF
      -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      -DCMAKE_C_COMPILER=#{ENV.cc}
      -DOPENSSL_ROOT_DIR=#{openssl_root}
      -DUSE_CUDA=OFF
      -DUSE_DISTRIBUTED=ON
      -DUSE_METAL=OFF
      -DUSE_MKLDNN=OFF
      -DUSE_NNPACK=OFF
      -DUSE_OPENMP=ON
      -DUSE_SYSTEM_EIGEN_INSTALL=ON
      -DUSE_SYSTEM_PYBIND11=ON
    ]
    # Remove when https://github.com/pytorch/pytorch/issues/67974 is addressed
    args << "-DUSE_SYSTEM_BIND11=ON"

    system "cmake", "-B", "build", "-S", ".", *std_cmake_args, *args

    # Avoid references to Homebrew shims
    inreplace "build/caffe2/core/macros.h", Superenv.shims_path/ENV.cxx, ENV.cxx

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <torch/torch.h>
      #include <iostream>

      int main() {
        torch::Tensor tensor = torch::rand({2, 3});
        std::cout << tensor << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{include}/torch/csrc/api/include",
                    "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10"
    system "./test"
  end
end
