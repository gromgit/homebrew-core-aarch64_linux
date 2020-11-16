class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.5.2.tar.gz"
  sha256 "e409fda0bd949e997f63de4d422a8f17ccc9cb0d58f11403bd309c7a93aa0d6b"
  license "MIT"
  head "https://github.com/odygrd/quill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9bd7b9972f4b0dba81202bb49a47695c08e7b6581627cd7df94e8072c66c0aa5" => :big_sur
    sha256 "005bd68d183a4ef347d73b59ddbd273b1c8bc2d35400f5acef88294fbb288bc8" => :catalina
    sha256 "a665a6c752e4482c0582bdbd0fe1248f72b5369bce53d331bae366db53fe2b10" => :mojave
    sha256 "d76aae3da313beb3338b134472377298f5fb56d6d619bd0cd1465557e25870c5" => :high_sierra
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
