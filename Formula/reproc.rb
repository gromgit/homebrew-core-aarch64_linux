class Reproc < Formula
  desc "Cross-platform (C99/C++11) process library"
  homepage "https://github.com/DaanDeMeyer/reproc"
  url "https://github.com/DaanDeMeyer/reproc/archive/refs/tags/v14.2.3.tar.gz"
  sha256 "ea87db7a780a81bc27bce3e6c8e5f31b831fb8a1d06c6b5c2e1c2554d1c55e00"
  license "MIT"
  head "https://github.com/DaanDeMeyer/reproc.git", branch: "main"

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = *std_cmake_args << "-DREPROC++=ON"
    system "cmake", "-S", ".", "-B", "build", *args, "-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rm_rf "build"
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    lib.install "build/reproc/lib/libreproc.a", "build/reproc++/lib/libreproc++.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <reproc/run.h>

      int main(void) {
        const char *args[] = { "echo", "Hello, world!", NULL };
        return reproc_run(args, (reproc_options) { 0 });
      }
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <reproc++/run.hpp>

      int main(void) {
        int status = -1;
        std::error_code ec;

        const char *args[] = { "echo", "Hello, world!", NULL };
        reproc::options options;

        std::tie(status, ec) = reproc::run(args, options);
        return ec ? ec.value() : status;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lreproc", "-o", "test-c"
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lreproc++", "-o", "test-cpp"

    assert_equal "Hello, world!", shell_output("./test-c").chomp
    assert_equal "Hello, world!", shell_output("./test-cpp").chomp
  end
end
