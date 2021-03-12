class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.9.2-source.zip"
  sha256 "838a2c804573f927c044e5f45a8feb297683a7047ab62dfac8ddc995498db11c"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download/"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f0f0ff88d204270184f93bf00884d36e85c5ffe544422a70a618b344f0ac60ab"
    sha256 cellar: :any, big_sur:       "cc6ef2185004324fd875f69d36246b5f725af58df2111610944dfb0ec6676eb0"
    sha256 cellar: :any, catalina:      "9715854b6b78ee74ddd122e4a0e8945da5aa7b9eb7aa60bfe5bfb0e9cd0cd1b8"
    sha256 cellar: :any, mojave:        "508dd4e8960a31421f8727aa9b3ae39157a88ad8dcf45e98c9359539964e7bcc"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DANTLR4_INSTALL=ON", *std_cmake_args
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <antlr4-runtime.h>
      int main(int argc, const char* argv[]) {
          try {
              throw antlr4::ParseCancellationException() ;
          } catch (antlr4::ParseCancellationException &exception) {
              /* ignore */
          }
          return 0 ;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}/antlr4-runtime", "test.cc",
                    "-L#{lib}", "-lantlr4-runtime", "-o", "test"
    system "./test"
  end
end
