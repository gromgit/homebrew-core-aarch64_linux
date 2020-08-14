class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.900.2.tar.xz"
  sha256 "d78658c9442addf7f718eb05881150ee3ec25604d06dd3af4942422b3ce26d05"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "a9d493551b5b30c28ad0b8fd6cf03c81401f516b056ac7b1e020fa0d2d3a19d2" => :catalina
    sha256 "664ed8eb28fe3c6b84d752c2cf402d088c9769b7a496b6283c090f84ebbf8144" => :mojave
    sha256 "991456aa8ddc477c001e717ecc668cbef96f7abca83d8fb36dc058a915693476" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "openblas"
  depends_on "hdf5"
  depends_on "superlu"
  depends_on "szip"

  def install
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API -DH5Ovisit_vers=1"

    system "cmake", ".", "-DDETECT_HDF5=ON", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
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
    assert_equal shell_output("./test").to_i, version.to_s.to_i
  end
end
