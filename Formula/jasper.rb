class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.23.tar.gz"
  sha256 "20facc904bd9d38c20e0c090b1be3ae02ae5b2703b803013be2ecad586a18927"
  license "JasPer-2.0"

  bottle do
    sha256 "5bdfa3e3512a37f98fee42ebb1de00d6f1252344a827bc60329c4a1337d1ef0b" => :big_sur
    sha256 "b65f3d2c159fa0c9be917e074d79d9ffd79bee8e9b320a5e62bca4e425a9009c" => :arm64_big_sur
    sha256 "0920d1450e3545eb62d7446c8c1d8dcb9bc404e4a846230eb52963a212c43667" => :catalina
    sha256 "d29a2f3e4b14c7e4756150764d36c2fe7780a62af94a8320feab5f27967cf451" => :mojave
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
