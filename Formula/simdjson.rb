class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v1.0.0.tar.gz"
  sha256 "fe54be1459b37e88abd438b01968144ed4774699d1272dd47a790b9362c5df42"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "de8aa7c888e15197fa0b143b10136abe39bc479d7d47a283f9ffb87ba5bc87d4"
    sha256 cellar: :any, big_sur:       "4552d7517d700aab4fb52235db8885154f3227afeb99c3afcdd7b9895775ea3e"
    sha256 cellar: :any, catalina:      "47a293950f8b604ff3f40b8c60a23eb6cfcbd9411b96f3e9f4458fa681297999"
    sha256 cellar: :any, mojave:        "aa11523cf29951aa4dfee2132745cd077116230fae4345f5671356514b9fe7ae"
  end

  depends_on "cmake" => :build

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
