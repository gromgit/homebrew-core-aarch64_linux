class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v1.6.3.tar.gz"
  sha256 "471c877671f672e4119e5f49143890c5ce2efff80a52a5eaf7ef3730eb3e1738"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    cellar :any
    sha256 "bfd70f45191882fa8e44ecd0a072b2d9f981691e29bc18e81f4af2490072fa0a" => :catalina
    sha256 "600e249858d5f708ddab5d69d122bf21f9171f1f6e5ed68678d3d0765845015d" => :mojave
    sha256 "049612ee44864e35c738681339bfafb1c79f106a451d49243c8f5c755ab815c1" => :high_sierra
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
