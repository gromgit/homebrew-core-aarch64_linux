class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v1.6.5.tar.gz"
  sha256 "6258d961fe1757b70d10cf34f0925079401ffae264f056b15024270b11d5c1eb"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    cellar :any
    sha256 "724b8924bc0d39437faf94f9d7638ca662017ee056f3eb261a0ffd579b0c0364" => :catalina
    sha256 "fa5e5faa0fca720060715da08d718bb94cbbac4e40a4e4c4692559c0056e7743" => :mojave
    sha256 "d32b696e19b4c16daf0a480eeec220827042b4260c609f7bbfecb052477bd6ae" => :high_sierra
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
