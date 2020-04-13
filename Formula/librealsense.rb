class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.34.0.tar.gz"
  sha256 "130e38f759dbe420ef531cf7c1587f50161f4f4de4d3b008f569abd6d404dc23"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "55c191f8d7c5d3bff8e87d5762ee87961d4bf8e9d906cd764a6705ab325ec484" => :catalina
    sha256 "ee3f7867f8546c82fe0d651970e6e83fcbf2643d016fa90afc29c6075845d45b" => :mojave
    sha256 "a02077f6de838c726d240dc4f3c6b3bb7d56760d5fd444723eacf2511b479927" => :high_sierra
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
