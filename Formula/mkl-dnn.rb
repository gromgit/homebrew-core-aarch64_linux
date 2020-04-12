class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v1.3.tar.gz"
  sha256 "b87c23b40a93ef5e479c81028db71c4847225b1a170f82af5e79f1cda826d3bf"

  bottle do
    cellar :any
    sha256 "8ec4f729539f1e8b6ca35277013d0b5fe85039fdc743177d425f8a1e2f001905" => :catalina
    sha256 "675a0cbbcb2f62cfb2f45f4bf4f33101e0177a89b2f7527611dba342a40b8e13" => :mojave
    sha256 "cfa114bbcc5fd3c64f9ce1c9e60112ea098643a21f0ff2af8b530ec084c3241b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "doc"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mkldnn.h>
      int main() {
        mkldnn_engine_t engine;
        mkldnn_status_t status = mkldnn_engine_create(&engine, mkldnn_cpu, 0);
        return !(status == mkldnn_success);
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lmkldnn", "test.c", "-o", "test"
    system "./test"
  end
end
