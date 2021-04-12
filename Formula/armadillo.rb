class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.4.0.tar.xz"
  sha256 "a2540f1f8ee1991ba1b14941daa3986fb774484fc678978d4d00bba87360102e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d56e5d6fe1fbb10bb83861fa6f32afd6ab9908d7eed7ba323a82e64e4903118a"
    sha256 cellar: :any, big_sur:       "149e40e4ba150a3cbee0e5f8ae1a4fa833db11b817cb9b15f2b68e18bfce291e"
    sha256 cellar: :any, catalina:      "546c068771d2adb1bd70338ab723713cc796c07356824d1db75d76c0f6b01afd"
    sha256 cellar: :any, mojave:        "37dbe1c56e8ad5811a02801702394b344de61d35e5c804a95ed9c896a6956388"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "openblas"
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal shell_output("./test").to_i, version.to_s.to_i
  end
end
