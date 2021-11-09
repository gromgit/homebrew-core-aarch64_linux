class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.4.3.tar.gz"
  sha256 "153bc08827c3007276400262ebdf4234ea7b4cfd2844440dd4641b7b0cc4f88e"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "78d1e8bab0bdeed81f2f6597274cc69616c5833bb3e568e5cb9d35a5cd1ed74b"
    sha256 cellar: :any,                 arm64_big_sur:  "10f08b24fbf8446eabec027a28a2161284616fe3b175ec54044138b4fdebea4c"
    sha256 cellar: :any,                 monterey:       "315a71f8ad8b1b8ec2f1216b2f7ed7581c463bb7c8b3b03e806aef527b275f2c"
    sha256 cellar: :any,                 big_sur:        "7321072e3750241e728c82356af833c79c37733f310d868b9618952f57bd35c1"
    sha256 cellar: :any,                 catalina:       "93a396beb7dffd8f0bf4571e703e5b1a2752801e905062cb5384ca1a5a360ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76e6f92d861d557bc9f803739f4d96db4d8d2f9a4bad41b3d2efe1f895bf3bec"
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
    system ENV.cc, "test.c", "-L#{lib}", "-lmkldnn", "-o", "test"
    system "./test"
  end
end
