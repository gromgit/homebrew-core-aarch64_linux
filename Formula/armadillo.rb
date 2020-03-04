class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.850.1.tar.xz"
  sha256 "d4c389b9597a5731500ad7a2656c11a6031757aaaadbcafdea5cc8ac0fd2c01f"
  revision 1

  bottle do
    cellar :any
    sha256 "f5747f1e0d77cb7b7474ff6ab140929a7857561a5b98b6a9c53b7aa2595a9ab1" => :catalina
    sha256 "0a0a345d802ce2fd8c6e5914116d738839952ce3e6dd978bf961d8ff9d9d269b" => :mojave
    sha256 "2244d20f4c15f846a1db5382707d1653b7f5fb165524d5b27413735ac4d68851" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "szip"

  def install
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API -DH5Ovisit_vers=1"

    system "cmake", ".", "-DDETECT_HDF5=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <armadillo>

      int main(int argc, char** argv) {
        std::cout << arma::arma_version::as_string() << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal Utils.popen_read("./test").to_i, version.to_s.to_i
  end
end
