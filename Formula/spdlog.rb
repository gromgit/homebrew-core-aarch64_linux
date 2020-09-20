class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.8.0.tar.gz"
  sha256 "1e68e9b40cf63bb022a4b18cdc1c9d88eb5d97e4fd64fa981950a9cacf57a4bf"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    cellar :any
    sha256 "18e5e0d8170f15973dbf0135bed18b16e615e38c517da40cebc20f1fe2acbf5e" => :catalina
    sha256 "a5c2bd875543f3fe3a5da3b80b16b56273fc99d0ff2bc31d98a617b42d740fe6" => :mojave
    sha256 "0a5ba4561cabb72ff56038df3b6ee95c37d5c68f65d2c7acd5e5c540aa6e3713" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "fmt"

  def install
    ENV.cxx11

    inreplace "include/spdlog/tweakme.h", "// #define SPDLOG_FMT_EXTERNAL", "#define SPDLOG_FMT_EXTERNAL"

    mkdir "spdlog-build" do
      args = std_cmake_args + %W[
        -Dpkg_config_libdir=#{lib}
        -DSPDLOG_BUILD_BENCH=OFF
        -DSPDLOG_BUILD_TESTS=OFF
        -DSPDLOG_FMT_EXTERNAL=ON
      ]
      system "cmake", "..", "-DSPDLOG_BUILD_SHARED=ON", *args
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DSPDLOG_BUILD_SHARED=OFF", *args
      system "make"
      lib.install "libspdlog.a"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "spdlog/sinks/basic_file_sink.h"
      #include <iostream>
      #include <memory>
      int main()
      {
        try {
          auto console = spdlog::basic_logger_mt("basic_logger", "#{testpath}/basic-log.txt");
          console->info("Test");
        }
        catch (const spdlog::spdlog_ex &ex)
        {
          std::cout << "Log init failed: " << ex.what() << std::endl;
          return 1;
        }
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{Formula["fmt"].opt_lib}", "-lfmt", "-o", "test"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
