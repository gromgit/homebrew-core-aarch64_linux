class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/v1.3.8.tar.gz"
  sha256 "3ea7257914ad55eabc43a997b323ba0dfee0a9b010d648b6d5b0c96425102d0e"
  license "BSD-3-Clause"
  head "https://github.com/devernay/cminpack.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cminpack"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2c2d78f8212b7454e44a3f2a877da3c7e2e25d1cc22f612078635ea814888169"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON",
                         "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
                         "-DCMINPACK_LIB_INSTALL_DIR=lib",
                         *std_cmake_args
    system "make", "install"

    man3.install Dir["doc/*.3"]
    doc.install Dir["doc/*"]
    pkgshare.install "examples/thybrdc.c"
  end

  test do
    system ENV.cc, "-I#{include}/cminpack-1", pkgshare/"thybrdc.c",
                   "-L#{lib}", "-lcminpack", "-lm", "-o", "test"
    assert_match "number of function evaluations", shell_output("./test")
  end
end
