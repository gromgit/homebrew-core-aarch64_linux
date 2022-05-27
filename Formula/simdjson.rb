class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v2.0.1.tar.gz"
  sha256 "581e508210614a5024edf79e0b65db943ab5711cc42163826bcbf3df6a5e34d1"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2d56a7a10bf960005696106b34b925e2351facbb0ad46c1c0e7e17a2927a8a17"
    sha256 cellar: :any,                 arm64_big_sur:  "1ba6d99b2c0c08b51c406b06ba0a304b2032d02999d3f57318395b4906d5c9b9"
    sha256 cellar: :any,                 monterey:       "edea3e6fb9e7227a6e07a4d88637e657b4bcef21eb7c7ec5291e03177a972e32"
    sha256 cellar: :any,                 big_sur:        "35ce3872381e3a1cd7044a38baca0f44524b9614628e2fe0a53a84473f2665de"
    sha256 cellar: :any,                 catalina:       "295f10b13635009b5951d2f777b768a525fde7e29a443438099a86cbe35cc395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea4ea7e76ef351a54d809e56d5b92b05af7e86000ce9df13e85f620b989c59db"
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
