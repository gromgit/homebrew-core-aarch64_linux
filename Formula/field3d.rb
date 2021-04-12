class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.3.tar.gz"
  sha256 "b6168bc27abe0f5e9b8d01af7794b3268ae301ac72b753712df93125d51a0fd4"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6a5d7eb6b91567ebe0082b1170583bf7035fa2c0c8dd0c360bd9bcea11dc1d5c"
    sha256 cellar: :any, big_sur:       "fd226f9edf79d0ea4f135568c60ab222c34ca001042f9dc20bc9f654e4bbcb1c"
    sha256 cellar: :any, catalina:      "d1133d0d7528ed082ef3b6ac8fb81da79682592826d0cfb9fd0ac8208b9ed98f"
    sha256 cellar: :any, mojave:        "0e3066f2e84a3573f468119b60f3c854fe738519cb2e2aef29a2fb0830a9f1b1"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "hdf5"
  depends_on "ilmbase"

  def install
    ENV.cxx11
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    man1.install "man/f3dinfo.1"
    pkgshare.install "contrib", "test", "apps/sample_code"
  end

  test do
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lField3D",
           "-I#{Formula["boost"].opt_include}",
           "-L#{Formula["boost"].opt_lib}", "-lboost_system",
           "-I#{Formula["hdf5"].opt_include}",
           "-L#{Formula["hdf5"].opt_lib}", "-lhdf5",
           "-I#{Formula["ilmbase"].opt_include}",
           pkgshare/"sample_code/create_and_write/main.cpp",
           "-o", "test"
    system "./test"
  end
end
