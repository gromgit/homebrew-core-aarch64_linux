class Matplotplusplus < Formula
  desc "C++ Graphics Library for Data Visualization"
  homepage "https://github.com/alandefreitas/matplotplusplus"
  url "https://github.com/alandefreitas/matplotplusplus/archive/v1.1.0.tar.gz"
  sha256 "5c3a1bdfee12f5c11fd194361040fe4760f57e334523ac125ec22b2cb03f27bb"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "da37512436dab0d5d57a352a3af69cfd93408afbcda7b81e91dc16f299981c90"
    sha256 cellar: :any, arm64_big_sur:  "74d1140f6be97349816d42070c8e3846ac64be9798c0b3e2e72e8906f117baf1"
    sha256 cellar: :any, monterey:       "c44a46d9b834941888f3e3c6cae35d544659012620d68d20bc2a2a79e72c3c61"
    sha256 cellar: :any, big_sur:        "8803e7a64e17c43e5dfb22dd6286b3693477e28be948817afda4c51e9cbdba2c"
    sha256 cellar: :any, catalina:       "6662b7fbec4d171db186c4dbf1d64648a15a718a24a3ab0c59bdd635b401c578"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gnuplot"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  fails_with :clang do
    build 1100
    cause "cannot run simple program using std::filesystem"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON", "-DBUILD_EXAMPLES=OFF"
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/exporting/save/save_1.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lmatplot", "-o", "test"
    system "./test"
    assert_predicate testpath/"img/barchart.svg", :exist?
  end
end
