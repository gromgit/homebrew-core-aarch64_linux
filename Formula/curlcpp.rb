class Curlcpp < Formula
  desc "Object oriented C++ wrapper for CURL (libcurl)"
  homepage "https://josephp91.github.io/curlcpp"
  url "https://github.com/JosephP91/curlcpp/archive/refs/tags/2.0.tar.gz"
  sha256 "818e6d0cc027be6f0bd65dfed142c64a97aed1f0ae8e9f1490d19e4375734304"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "87922690e232f15e852f33a4636e9b9a4f8458b1c244c4b8465d80c09bd9522c"
    sha256 cellar: :any,                 arm64_big_sur:  "f6980da3dd9bf14016f7e7832e4981ea87d077958e2dc225eb4eacc3ddef87bf"
    sha256 cellar: :any,                 monterey:       "deeef2d85d2923bc14f62f48e91b2581e028de97c6c087e41868b2e7c27eb055"
    sha256 cellar: :any,                 big_sur:        "205dbd2d04e1b71c31d53d7e331bb27745d05329dd87426ac5906a489cb88755"
    sha256 cellar: :any,                 catalina:       "73d4a493d900c4d5b03e4fe0eb1b657f84075404c8ceb45ce116e36af169de85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36a715a64edbd313a814be1d7b31aa792290a1828fef45a0ff4e1c06f3eaa37a"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <ostream>

      #include "curlcpp/curl_easy.h"
      #include "curlcpp/curl_form.h"
      #include "curlcpp/curl_ios.h"
      #include "curlcpp/curl_exception.h"

      using std::cout;
      using std::endl;
      using std::ostringstream;

      using curl::curl_easy;
      using curl::curl_ios;
      using curl::curl_easy_exception;
      using curl::curlcpp_traceback;

      int main() {
          // Create a stringstream object
          ostringstream str;
          // Create a curl_ios object, passing the stream object.
          curl_ios<ostringstream> writer(str);

          // Pass the writer to the easy constructor and watch the content returned in that variable!
          curl_easy easy(writer);
          easy.add<CURLOPT_URL>("https://google.com");
          easy.add<CURLOPT_FOLLOWLOCATION>(1L);

          try {
              easy.perform();
          } catch (curl_easy_exception &error) {
              // If you want to print the last error.
              std::cerr<<error.what()<<std::endl;

              // If you want to print the entire error stack you can do
              error.print_traceback();
          }
          return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lcurlcpp", "-lcurl", "-o", "test"
    system "./test"
  end
end
