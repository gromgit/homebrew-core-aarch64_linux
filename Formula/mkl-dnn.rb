class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v1.4.tar.gz"
  sha256 "54737bcb4dc1961d32ee75da3ecc529fa48198f8b2ca863a079e19a9c4adb70f"

  bottle do
    cellar :any
    sha256 "28d3e88f803aecac82aaf70c6fb5f9ec5372ce68446bb71cd38e75edc5fa97b8" => :catalina
    sha256 "70128d845c6d9ca4c9d2798bed1c2f5ed19cb73e4da841e4f7d8e06462eca5fb" => :mojave
    sha256 "c3a25f4b25ff821a136cf9c7eee62e38185314a287bc9fcff2596b7c1f31dcfc" => :high_sierra
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
