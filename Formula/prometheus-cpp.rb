class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp.git",
    tag:      "v0.9.0",
    revision: "023c93e4e504d0954b01cdde13bd293865880388",
    shallow:  false
  license "MIT"
  head "https://github.com/jupp0r/prometheus-cpp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a7554ae3fc4618f5b405aa365f2c48192304406a5aba72611110cb909e1669f" => :catalina
    sha256 "c843326804e9e84640a31254e793e15b7956aa69be769d8bd0d6888bf7933a0f" => :mojave
    sha256 "3b9b31ccd9421f6777605f7c0b1921b0dca02a3be8c143b5468e32ccf7b36536" => :high_sierra
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <prometheus/Registry.h>
      int main() {
        prometheus::Registry reg;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lprometheus-cpp-core", "-o", "test"
    system "./test"
  end
end
