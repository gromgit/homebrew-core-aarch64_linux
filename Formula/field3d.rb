class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.3.tar.gz"
  sha256 "b6168bc27abe0f5e9b8d01af7794b3268ae301ac72b753712df93125d51a0fd4"
  license "BSD-3-Clause"
  revision 8

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "dd7a5bc0753b005117617530c6be75c17df59a7c4a031ae1063ba6a87412f88e"
    sha256 cellar: :any,                 arm64_big_sur:  "a9a29067970e29b57a31c05dae9bae5b6bd38325f46d9b82df207834c4f60179"
    sha256 cellar: :any,                 monterey:       "3819ae35d571632bcfff8cb126caccdca67617eb51eb5094b48297badd77388f"
    sha256 cellar: :any,                 big_sur:        "7a111aeb16124fb8197a0226ec5868bb85ba28e9d52307c23d0e8363a15a52a0"
    sha256 cellar: :any,                 catalina:       "0a8b6db945e6d4316b0b5d908d4b9a48ab0e15814d027228c6d3e0eae3b53d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c726a57df42221704e420460d752a95318e3a48d6b157024bb2d97d4306d508c"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "hdf5"
  depends_on "ilmbase"

  fails_with gcc: "5"

  def install
    ENV.cxx11
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DMPI_FOUND=OFF"
      system "make", "install"
    end
    man1.install "man/f3dinfo.1"
    pkgshare.install "contrib", "test", "apps/sample_code"
  end

  test do
    system ENV.cxx, "-std=c++11", "-I#{include}",
           pkgshare/"sample_code/create_and_write/main.cpp",
           "-L#{lib}", "-lField3D",
           "-I#{Formula["boost"].opt_include}",
           "-L#{Formula["boost"].opt_lib}", "-lboost_system",
           "-I#{Formula["hdf5"].opt_include}",
           "-L#{Formula["hdf5"].opt_lib}", "-lhdf5",
           "-I#{Formula["ilmbase"].opt_include}",
           "-o", "test"
    system "./test"
  end
end
