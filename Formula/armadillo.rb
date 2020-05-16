class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.880.1.tar.xz"
  sha256 "900f3e8d35d8b722217bed979fa618faf6f3e4f56964c887a1fce44c3d4c4b9f"

  bottle do
    cellar :any
    sha256 "72582d2bfbcc6cc30bfda48af05e35778d84d985f0806f162afcaf0bad847be4" => :catalina
    sha256 "0f237a879ad3fe27443efb3a0dfcb5a054168e5ba8e0306f5bad3c7e3855e421" => :mojave
    sha256 "e1bd618d408c96e1c75b7c87d2ad0e5ce567a4e517ed7f9626ea68ce8b702c57" => :high_sierra
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
