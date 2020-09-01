class Numcpp < Formula
  desc "C++ implementation of the Python Numpy library"
  homepage "https://dpilger26.github.io/NumCpp"
  url "https://github.com/dpilger26/NumCpp/archive/Version_2.3.0.tar.gz"
  sha256 "5e09a855a23b5a5757e7b0fcb941ebe88a94eefcc3ee197735cb55e59565fe52"
  license "MIT"
  head "https://github.com/dpilger26/NumCpp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82c6072f7b1dbb789af12774a997888b4a50411b9979ee24dfba865bca13aa3b" => :catalina
    sha256 "eee4970f2b66665c17a67b93d84296af236861b466e2d7db154f6535a70a1182" => :mojave
    sha256 "27cdc95505568b37fde713717f95006e44b1450dca0fcf64089c35d484be3e17" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <NumCpp.hpp>

      int main() {
          nc::NdArray<int> a = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
          a = nc::diagonal(a);
          for (int i = 0; i < nc::shape(a).cols; ++i)
              std::cout << a[i] << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "1\n5\n9\n", shell_output("./test")
  end
end
