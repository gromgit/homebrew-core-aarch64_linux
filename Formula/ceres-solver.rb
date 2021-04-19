class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.0.0.tar.gz"
  sha256 "10298a1d75ca884aa0507d1abb0e0f04800a92871cd400d4c361b56a777a7603"
  license "BSD-3-Clause"
  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6590abc459c48af9965f3d456b36ad0edb34502a5fb53c81530f5b5a1748b377"
    sha256 cellar: :any, big_sur:       "3553990ae1e702986b4ba78b5e73219c525f32fa92c91b9c4debf58992c2506f"
    sha256 cellar: :any, catalina:      "62cc6e437638a68e7b0c7b053e799a928a446ffe25635588f0b4635d8995ae27"
    sha256 cellar: :any, mojave:        "849c1cf12a1755149b155bfe6e2b2e6e773fec0773cb74f3ff04951ad8b6d69d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "tbb"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DLIB_SUFFIX=''"
    system "make"
    system "make", "install"
    pkgshare.install "examples", "data"
    doc.install "docs/html" unless build.head?
  end

  test do
    cp pkgshare/"examples/helloworld.cc", testpath
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(helloworld)
      find_package(Ceres REQUIRED)
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld Ceres::ceres)
    EOS

    system "cmake", "-DCeres_DIR=#{share}/Ceres", "."
    system "make"
    assert_match "CONVERGENCE", shell_output("./helloworld")
  end
end
