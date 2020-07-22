class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/archive/version-2.0.17.tar.gz"
  sha256 "9a3524aa17795ea10f476d7071e27dd9fc0077d9ffbf2ea49b9f18de0bfe7fa1"
  license "JasPer-2.0"

  bottle do
    rebuild 1
    sha256 "537ddcc7b31d400aa7c7e636b1d2710b8327ba4f2a2ee886c04224f3ed8ab17b" => :catalina
    sha256 "251ae8361f61929a9f69592cdd94b8fe456b526d9c205de087bd60cb47ffba9e" => :mojave
    sha256 "efd316074421556b39f0325bf7d9108236780ab9add71a41aab290033fc86dc6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "jpeg"

  def install
    mkdir "build" do
      # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
      # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      system "cmake", "..", "-DGLUT_glut_LIBRARY=#{glut_lib}", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DGLUT_glut_LIBRARY=#{glut_lib}", "-DJAS_ENABLE_SHARED=OFF", *std_cmake_args
      system "make"
      lib.install "src/libjasper/libjasper.a"
    end
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_predicate testpath/"test.bmp", :exist?
  end
end
