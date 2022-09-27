class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.09.26.00.tar.gz"
  sha256 "587a068fa72d771bacb7c3f00f84d3292208d96b65cfcdd24775aa45f254628b"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "74c9cf24cb18a66d168d6e77f88aacdd81f67bdfd1b7dc788de2abe915a64377"
    sha256 cellar: :any,                 arm64_big_sur:  "bf632e6a489074d30a08e699593b285cf0a442947f309d5c1bf19d9d2559f6ac"
    sha256 cellar: :any,                 monterey:       "b39a6902bb7ae16b643cb21c9b9fc5d668e16d976140467e77bb3f14f74d4410"
    sha256 cellar: :any,                 big_sur:        "6a02889b2744757c86555125f6ff0bb12dc878c7b56201e970bc77b93f448b5d"
    sha256 cellar: :any,                 catalina:       "d808dae75396da2291a2bddce2d35206cf966da3685cf7a63225e35e11bedf9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc95923a550281149004953f6219e31a4f49e29a3bd32eec3717416a2517ee6b"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
  depends_on "wangle"

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXTENSIONS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "fb303/thrift/gen-cpp2/BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    EOS

    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    ENV.append "CXXFLAGS", "-std=c++17"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
