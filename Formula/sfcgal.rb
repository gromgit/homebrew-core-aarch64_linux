class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.4.1/SFCGAL-v1.4.1.tar.gz"
  sha256 "1800c8a26241588f11cddcf433049e9b9aea902e923414d2ecef33a3295626c3"
  license "LGPL-2.0-or-later"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "27c79e4e9db21d023e67cc8b3c36962a5192fcf0a41e36f0716c5c2d4389db42"
    sha256 cellar: :any,                 arm64_big_sur:  "c8c850d7b183f314c345e09eb950f551a92520fe6474ffa98bce470880ccbdaf"
    sha256 cellar: :any,                 monterey:       "9c99287f0795eac493cf6ef6b692a4b7a756a7b8a883b3c59b94c70208ac2868"
    sha256 cellar: :any,                 big_sur:        "3f1bef94cb398dc0ce41104ee1bcaa7da50abf781aa6e5484993322280dd0896"
    sha256 cellar: :any,                 catalina:       "0236c932bfaf71363674a06ff7b22afa8e970c2d11fdc50d4d9e412f08bbe8bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df8e58a9120cb041f88f928e733d5eb0577dbdaa5aab13acaeca455ca3f60ada"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  # error: array must be initialized with a brace-enclosed initializer
  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
