class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.4.7.tar.gz"
  sha256 "44c20aa1000a8ed67ed6d541048aa7e5ea26a3bcb833a7232310414fc46b3ef9"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    cellar :any
    sha256 "11da8bfcaa21343a51eff42f2c9f7e87f5387bbbf0e12fd1e36dbad4c8eb040c" => :catalina
    sha256 "06cd4d16ce496a7f5f3c1ec7e293c0cfa565c80442838248eaadcb9e3da42116" => :mojave
    sha256 "017145ef48f08c85b7f25a29dac104c48078a070c346397d88a1b472e8db61a8" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + ["-DSIMDJSON_JUST_LIBRARY=ON"]
    system "cmake", ".", *args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", *args, "-DSIMDJSON_BUILD_STATIC=ON"
    system "make"
    lib.install "src/libsimdjson.a"
  end

  test do
    (testpath/"test.json").write "{\"name\":\"Homebrew\",\"isNull\":null}"
    (testpath/"test.cpp").write <<~EOS
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
