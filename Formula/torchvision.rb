class Torchvision < Formula
  include Language::Python::Virtualenv

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
  depends_on "ninja" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python-typing-extensions"
  depends_on "pytorch"

  on_macos do
    depends_on "libomp"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    jpeg = Formula["jpeg-turbo"]
    inreplace "setup.py",
      "(jpeg_found, jpeg_conda, jpeg_include, jpeg_lib) = find_library(\"jpeglib\", vision_include)",
      "(jpeg_found, jpeg_conda, jpeg_include, jpeg_lib) = (True, False, \"#{jpeg.include}\", \"#{jpeg.lib}\")"

    virtualenv_install_with_resources using: "python@3.10"

    pkgshare.install "examples"
  end

  test do
    # test that C++ libraries are available
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

    # test that the `torchvision` Python module is available
    cp test_fixtures("test.png"), "test.png"
    system libexec/"bin/python", "-c", <<~EOS
      import torch
      import torchvision
      t = torchvision.io.read_image("test.png")
      assert isinstance(t, torch.Tensor)
    EOS
  end
end
