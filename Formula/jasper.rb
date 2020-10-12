class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.22.tar.gz"
  sha256 "afc4166bff29b8a0dc46ed5e8d6a208d7976fccfd0b1146e3400c8b2948794a2"
  license "JasPer-2.0"

  bottle do
    sha256 "e87b1fe48ee5d35852b75daa469f11ea4f2630ce93802bd28b07bdca5edb9151" => :catalina
    sha256 "15ca0badba803c5aa7459dbb8e2a6a77289b8dfed88d996def81eb6ee31d12f8" => :mojave
    sha256 "d94157624007469701b5b64f67c640a59baee1ae6316176e6b8606396dd15232" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "jpeg"

  def install
    mkdir "build" do
      # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
      # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"

      system "cmake", "..",
        "-DGLUT_glut_LIBRARY=#{glut_lib}",
        "-DJAS_ENABLE_AUTOMATIC_DEPENDENCIES=false",
        *std_cmake_args
      system "make"
      system "make", "install"
      system "make", "clean"

      system "cmake", "..",
        "-DGLUT_glut_LIBRARY=#{glut_lib}",
        "-DJAS_ENABLE_SHARED=OFF",
        *std_cmake_args
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
