class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v1.6.2.tar.gz"
  sha256 "83533fcf81cd4c4565bf640b895d1ea0a4563a5dac88af8e5c05813f1af13e25"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    cellar :any
    sha256 "9bb8801db63897577d4d7fc457c5a3f69b9ca0f9511a1a4e2e89cc95028af3cf" => :catalina
    sha256 "5c0cc2276a5579104de26e19e34582c7d526cfa0f9e81d4fb3b280481dfba50c" => :mojave
    sha256 "5f9a8b8f08712cbd1496666fa28febb1fc057517286b2491b9fab27f85ed3bfe" => :high_sierra
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
