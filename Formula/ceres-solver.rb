class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-1.14.0.tar.gz"
  sha256 "4744005fc3b902fed886ea418df70690caa8e2ff6b5a90f3dd88a3d291ef8e8e"
  revision 14
  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b361ff56ef92ad9f331eb3555675c41dcda52bb1f00d0918c09a182207689cf4" => :big_sur
    sha256 "e54c5be54b9a2e8d0af4860148d6e7d7c44edca7ce1c397b54a776c1730f03cd" => :catalina
    sha256 "0a091d6adf630d059340d1c4e69836fc9ecbbac804b23f855095ad9b0473a6b0" => :mojave
  end

  depends_on "cmake"
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "suite-sparse"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DEIGEN_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3",
                    "-DMETIS_LIBRARY=#{Formula["metis"].opt_lib}/#{shared_library("libmetis")}",
                    "-DGLOG_INCLUDE_DIR_HINTS=#{Formula["glog"].opt_include}",
                    "-DGLOG_LIBRARY_DIR_HINTS=#{Formula["glog"].opt_lib}",
                    "-DTBB=OFF", "-DBUILD_EXAMPLES=OFF", "-DLIB_SUFFIX=''"
    system "make"
    system "make", "install"
    pkgshare.install "examples", "data"
    doc.install "docs/html" unless build.head?
  end

  test do
    cp pkgshare/"examples/helloworld.cc", testpath
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 2.8)
      project(helloworld)
      find_package(Ceres REQUIRED)
      include_directories(${CERES_INCLUDE_DIRS})
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld ${CERES_LIBRARIES})
    EOS

    system "cmake", "-DCeres_DIR=#{share}/Ceres", "."
    system "make"
    assert_match "CONVERGENCE", shell_output("./helloworld")
  end
end
