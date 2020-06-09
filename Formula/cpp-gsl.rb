class CppGsl < Formula
  desc "Microsoft's C++ Guidelines Support Library"
  homepage "https://github.com/Microsoft/GSL"
  url "https://github.com/Microsoft/GSL/archive/v3.1.0.tar.gz"
  sha256 "d3234d7f94cea4389e3ca70619b82e8fb4c2f33bb3a070799f1e18eef500a083"
  head "https://github.com/Microsoft/GSL.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e9dfbc376a213a6208fce22c4070ffd0ac7647f1304e97e5ddb01494c86bc0b" => :catalina
    sha256 "0e9dfbc376a213a6208fce22c4070ffd0ac7647f1304e97e5ddb01494c86bc0b" => :mojave
    sha256 "0e9dfbc376a213a6208fce22c4070ffd0ac7647f1304e97e5ddb01494c86bc0b" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DGSL_TEST=false", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gsl/gsl>
      int main() {
        gsl::span<int> z;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++14"
    system "./test"
  end
end
