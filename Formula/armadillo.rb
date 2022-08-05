class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-11.2.3.tar.xz"
  sha256 "4c2e97ce60707fc1f348f44f7af0cb6d2466d0aad0d0ea4bf5d5dc180e6cba41"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "07eeff86ff7876d13cf5f91171b8353a38877c8891e1c0f5786a4198234ef7d5"
    sha256 cellar: :any,                 arm64_big_sur:  "49a663737fe8af7ac5a3ea659fb47d79b7909849dfce52e173ddc200dd5d1a8c"
    sha256 cellar: :any,                 monterey:       "f8848120e04f90ef2bfce9f2aa5acc2fd68551156a92294abea6cafc2e6152e7"
    sha256 cellar: :any,                 big_sur:        "b2f59c579da6d514b1d40ba18b169f59c4a4e3e119a6c463aa24e9c55e00f3b6"
    sha256 cellar: :any,                 catalina:       "df72fcb1528e9aee9cb9f3eaf1f3bd85ebf7f8d51a5b1c86e8043967da40bf42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3e48f9f07bb91610a8d595845df2b55249c413e1de2ddfa08a7ca8701fb30f3"
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
