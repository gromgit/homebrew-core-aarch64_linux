class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.3.9/SFCGAL-v1.3.9.tar.gz"
  sha256 "4f8ecfaa0d9ac5d8d7969f767ce3abadc7cc64059a11481e4bc497f04d5f6598"
  license "LGPL-2.0+"

  bottle do
    sha256 "f78f5ccb5b6feb0e7530770d3411149e4335ead8a2bcd08e275cbe7748b3c396" => :catalina
    sha256 "39a00ba2c7681850a601053adcfd8f920e2037aee5ebe9abf0f9a1b89ac674a1" => :mojave
    sha256 "86c543cb703b1d7885045354917e7da1a1fa3e52ca6749359f64ea736af74aa0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
