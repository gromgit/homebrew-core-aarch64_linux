class Openvdb < Formula
  desc "Sparse volume processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v8.0.0.tar.gz"
  sha256 "04a28dc24a744f8ac8bbc5636a949628edb02b7c84db24ad795429c8c739a9ee"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git"

  bottle do
    sha256 "20ab4ee266bd4d81cddc9173deace850a6f029f56a70bf1e6e9b7de597ab6272" => :big_sur
    sha256 "e9a79382494370f3a26852a967558b98bfb2b676925912f9b10dae107ab7f09e" => :arm64_big_sur
    sha256 "ae9c312f0e4c0559ba2a22734ce6472fb93b57badca7072e29ef05abe940064f" => :catalina
    sha256 "6fb5ca672cb6690dd655722105c4ad9aec9553437171f4b7ed4a0313de8e87d7" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "c-blosc"
  depends_on "glfw"
  depends_on "ilmbase"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  resource "test_file" do
    url "https://artifacts.aswf.io/io/aswf/openvdb/models/cube.vdb/1.0.0/cube.vdb-1.0.0.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  def install
    cmake_args = [
      "-DDISABLE_DEPENDENCY_VERSION_CHECKS=ON",
      "-DOPENVDB_BUILD_DOCS=ON",
    ]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *cmake_args
      system "make", "install"
    end
  end

  test do
    resource("test_file").stage testpath
    system "#{bin}/vdb_print", "-m", "cube.vdb"
  end
end
