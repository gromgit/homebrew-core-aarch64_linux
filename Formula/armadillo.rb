class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-11.2.3.tar.xz"
  sha256 "4c2e97ce60707fc1f348f44f7af0cb6d2466d0aad0d0ea4bf5d5dc180e6cba41"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "35e9b476a57feddb26f168b393e159a90925ad3c1051618a495844988b4be72a"
    sha256 cellar: :any,                 arm64_big_sur:  "7af947f3d26ce1cad6e1ceb20e955f605520bfcc2cebfa5ae562b0111bf19a85"
    sha256 cellar: :any,                 monterey:       "f8b79c84e296312210318ba06c64e4b307e18a9d54a59ec6ae2113f0dc1ddfc9"
    sha256 cellar: :any,                 big_sur:        "7a7a0600e5cfce3c92a7ec02dbce2ce5a7bacfe4c71cefbcc964919e4fcc36cb"
    sha256 cellar: :any,                 catalina:       "2995da36148638a7fd379cf83e79921c17b2037e1cf81d893f35f1617e835aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04e8649f6a4ad55ec89ab723593c880788b3032d46070665475e8ea1e4964ad3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "openblas"
  depends_on "superlu"

  def install
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API -DH5Ovisit_vers=1"

    system "cmake", ".", "-DDETECT_HDF5=ON", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
    system "make", "install"

    # Avoid cellar path references that are invalidated by version/revision bumps
    hdf5 = Formula["hdf5"]
    inreplace include/"armadillo_bits/config.hpp", hdf5.prefix.realpath, hdf5.opt_prefix
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
