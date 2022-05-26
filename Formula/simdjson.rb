class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v2.0.1.tar.gz"
  sha256 "581e508210614a5024edf79e0b65db943ab5711cc42163826bcbf3df6a5e34d1"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3f3bc094257433369b6d14d04f5d9b46ecbdd119599992e09c5faae57e0d1d19"
    sha256 cellar: :any,                 arm64_big_sur:  "410ce5b1f2ffcb1c9e537cf438176ce04b84b7b005617cb5a5cfafb3aaf01b03"
    sha256 cellar: :any,                 monterey:       "545a3c8c20f740830fcf548405aab54d91f1d51c1e7c733b2462d9a58cd6f02c"
    sha256 cellar: :any,                 big_sur:        "7f2199a54cd23fe8e89b2753c076730b77d3d454986324ad279031ef0f17a7d5"
    sha256 cellar: :any,                 catalina:       "3f08f942a90c878b2fa0045a5c553e7de237dee5de1f015c677288c87fbcbbf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5ae18ec7e3f38a94bc633dda79fd3dcc428ad4cadd2819d199ede85f5177fd8"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build"
    lib.install "build/libsimdjson.a"
  end

  test do
    (testpath/"test.json").write "{\"name\":\"Homebrew\",\"isNull\":null}"
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end
