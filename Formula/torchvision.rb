class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "c32fab734e62c7744dadeb82f7510ff58cc3bca1189d17b16aa99b08afc42249"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "f242a487e615c2a01556ba3497ab8cca0056e1bb20b737fb1c8dd5154609967d"
    sha256 cellar: :any,                 arm64_big_sur:  "b670aa10ef5a7066635ddf157cda580fd21d6e8ced717d61129bb41106a40bc6"
    sha256 cellar: :any,                 monterey:       "356d1df6d08682684441d9859214718af8f95c9d3f45ce08ef5a0c781e7b2ece"
    sha256 cellar: :any,                 big_sur:        "c90b4e0e2a12cea01077201e98d5364d50b2d6145588dfed6a1c2a13286c0f91"
    sha256 cellar: :any,                 catalina:       "0d94baa289e5efab0fc1e42c19b3634f56e456b0cd873e722ff9b81eecbad157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cadb5d0056033d49b5a43ca5051fd286e076f213e448c867cb9ff1116a33950"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "pytorch"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <assert.h>
      #include <torch/script.h>
      #include <torch/torch.h>
      #include <torchvision/vision.h>

      int main() {
        auto& ops = torch::jit::getAllOperatorsFor(torch::jit::Symbol::fromQualString("torchvision::nms"));
        assert(ops.size() == 1);
      }
    EOS
    pytorch = Formula["pytorch"]
    openmp_flags = if OS.mac?
      libomp = Formula["libomp"]
      %W[
        -Xpreprocessor -fopenmp
        -I#{libomp.opt_include}
        -L#{libomp.opt_lib} -lomp
      ]
    else
      %w[-fopenmp]
    end
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test", *openmp_flags,
                    "-I#{pytorch.opt_include}",
                    "-I#{pytorch.opt_include}/torch/csrc/api/include",
                    "-L#{pytorch.opt_lib}", "-ltorch", "-ltorch_cpu", "-lc10",
                    "-L#{lib}", "-ltorchvision"

    system "./test"
  end
end
