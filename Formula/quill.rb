class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.3.1.tar.gz"
  sha256 "00e491212139462d87897af02794d19b8a213ff190be59a6799aed515463ca78"
  head "https://github.com/odygrd/quill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "24d03f15c26bb3ffc1b226e25901201ac026ad908e01e14106c4279447fec1a8" => :catalina
    sha256 "c023e31209c239d2032e9cb2084d4a35d2aa83a320aac49f8cd8c2ae9c3af355" => :mojave
    sha256 "2e009b219ae4f2af91b78b3ae5920586a49e294cb1dcfba46a74c1a38cd56356" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "quill-build" do
      args = std_cmake_args
      args << ".."
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "quill/Quill.h"
      int main()
      {
        quill::start();
        quill::Handler* file_handler = quill::file_handler("#{testpath}/basic-log.txt", "w");
        quill::Logger* logger = quill::create_logger("logger_bar", file_handler);
        LOG_INFO(logger, "Test");
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-lquill", "-o", "test"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
