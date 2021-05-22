class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.9.4.tar.gz"
  sha256 "00f73c19e10af0f9b128a95ff584f84b20ff94b63929ba1214b1867d35838987"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "43241a6c6a6eda9cac0f5e64275bec37fba73a894e69cbb7af89a3636d65a8a9"
    sha256 cellar: :any, big_sur:       "1f2791d73d2351a3ddeeacad17f0b79fd60667d3c294fd3c6352d3e812d3c69f"
    sha256 cellar: :any, catalina:      "a5f204b3a099a053d42ec4bddf6260abe9b19aee314b3ab8c10c52410b6e972d"
    sha256 cellar: :any, mojave:        "8653e782bca90d75429045f98a08b4acf1f0b8e0649eedfdb755dd04a963507d"
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
