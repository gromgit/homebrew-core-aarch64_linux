class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.09.26.00/fizz-v2022.09.26.00.tar.gz"
  sha256 "d1907c211f0bccd4125d18fa6536bcc6169103de8920ef669995183493fe879b"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1f07b8c9c8e35e1f34ebf3791e824674fb96a89001471011bf051c4ff97973f9"
    sha256 cellar: :any,                 arm64_big_sur:  "ca3974cc190ef2ed07f5579e6e0c787551ab3b9753319e9cfe4880c0145b43aa"
    sha256 cellar: :any,                 monterey:       "fac8f7842e14979c32fd1e22b06b2baa77a734ffddc196c91b0d2a8e1f8e1eac"
    sha256 cellar: :any,                 big_sur:        "9abc5a456120742777f6de09a3df12e220614b70283f2d4c273ae12f78e47cfb"
    sha256 cellar: :any,                 catalina:       "856335fb47208d9a9198d0f395ff894215f9e6dcb9abfe4fe12928a94f1431ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d82c95608fdb1acf671e33914181c415e0d4acb804de0a97e17da4eb4849aa92"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "zstd"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fizz/client/AsyncFizzClient.h>
      #include <iostream>

      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfizz",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["libevent"].opt_lib}", "-levent",
                    "-L#{Formula["libsodium"].opt_lib}", "-lsodium",
                    "-L#{Formula["openssl@1.1"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "TLS", shell_output("./test")
  end
end
