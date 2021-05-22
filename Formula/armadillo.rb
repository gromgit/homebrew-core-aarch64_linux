class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.5.0.tar.xz"
  sha256 "ea990c34dc6d70d7c95b4354d9f3b0819bde257dbb67796348e91e196082cb87"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "16a55bb081fd578d63fe469850155739047b225ac997b6f650619616c1661837"
    sha256 cellar: :any, big_sur:       "83312deb84869ddc3e03881d00a15811a7c50823b263fba0f49d561bd72775a6"
    sha256 cellar: :any, catalina:      "3e8761e99368d27e3c2075f47db91899e3bd8907644279b357b48481f8890cc2"
    sha256 cellar: :any, mojave:        "7c844b71524fd6a32cba7fdaae4cda6c0895a688ccb46001543d710ac0b58982"
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
