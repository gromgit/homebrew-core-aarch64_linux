class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.39.0.tar.gz"
  sha256 "c9590a23195aa7546353e9672b3897f8f1df69ee20cd4250c91d6c8b404ed280"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git"

  livecheck do
    url "https://github.com/IntelRealSense/librealsense/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "79346e2ca9ce8b602bd6dd0a9e1526ae44d2d8345fd4dd4324a523d2d3478426" => :big_sur
    sha256 "9183343ffdb81b5f4bd5e0220e15f20fe73912d641e8a744b29aab4d96e7d4bb" => :catalina
    sha256 "1f96a994a35550a14f31bf220833924da5d5cf28d2aa1f4827a5695b8b177448" => :mojave
    sha256 "b0d3d9bcd64126f96a2ab642f2d6316de3d2f818e27abecb69ec10364d3abb8d" => :high_sierra
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
