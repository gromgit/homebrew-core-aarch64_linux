class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.35.2.tar.gz"
  sha256 "b49cf41b18c69dd11dc6f7f64d90e497d6816afb234dbedbf4259dc7f1ef1d76"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "50991510a4eb7078bea1eff9e385daa155599d6f61e9957cadce667c3b313626" => :catalina
    sha256 "9ad4235f81b91b9db15204bd5f9f4729c1b3c84cb15987134d27a123c9da9d13" => :mojave
    sha256 "4e68c85ee2ffa38b7f50a62e8f6b478c8dac69b9c09112f5e73082e9219fd54d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw"
  depends_on "libusb"

  def install
    args = std_cmake_args
    args << "-DENABLE_CCACHE=OFF"

    system "cmake", ".", "-DBUILD_WITH_OPENMP=OFF", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librealsense2/rs.h>
      #include <stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
