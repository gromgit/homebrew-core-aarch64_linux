class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-11.4.1.tar.xz"
  sha256 "dadb5fd35bc4dc251b36f5dd80729c3c588d65e2ecbcd4e4e359ad9cb04523fb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a1bf22ef2b2b6b612553464855e4b71995e8e4e7c1389d410727709f04ca33d3"
    sha256 cellar: :any,                 arm64_big_sur:  "7afe310a75e8238725a4578054db5b5bb4033cf926840ac7db010af7490e3489"
    sha256 cellar: :any,                 monterey:       "eebf608fe7eb2be4482d3d983456f87dcc2dd94201116f1e0e58332391794bec"
    sha256 cellar: :any,                 big_sur:        "6c16922362fc76ee70433cfafde8fc2c32170ccd9efda1de998cae3446b242ea"
    sha256 cellar: :any,                 catalina:       "9bef68b7401aa1e86258663efc0c636d9a576d67e6296fd817322aa523d19867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e434b3874884598dc8deca3ae3cb85d43326612e7add1cf7b7db8e2220eac51"
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
