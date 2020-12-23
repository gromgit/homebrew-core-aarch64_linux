class OpencvAT3 < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/3.4.13.tar.gz"
  sha256 "70230049194ae03ed8bfaab6cd1388569aa1b5c482d8b50d3af1cd2ae5a0b95d"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 "13a11fe4b516529fdc9ee5d2851e8d84e6b81ed0e4c32fc416ef3667d54956fd" => :big_sur
    sha256 "0132fe0511d0768d5e82b6c98c740d956a428d6bf252e7dc250317a224bcf69d" => :arm64_big_sur
    sha256 "c3b7b6d6ef2a5be47352f189f7fd027664fa63d0b01c3d8cb7902d393d6915f1" => :catalina
    sha256 "97c43f0d212704eff49078fe91699291af8a97996e0ff7605d3357b1c417f3c2" => :mojave
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "gflags"
  depends_on "glog"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "openexr"
  depends_on "python@3.9"
  depends_on "tbb"

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/3.4.13.tar.gz"
    sha256 "2ba1052eb52e5ad90ed32d2046504345a6bf3ab8ed57d101a492877c3bfae357"
  end

  def install
    ENV.cxx11

    resource("contrib").stage buildpath/"opencv_contrib"

    # Reset PYTHONPATH, workaround for https://github.com/Homebrew/homebrew-science/pull/4885
    ENV.delete("PYTHONPATH")

    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=ON
      -DBUILD_OPENEXR=OFF
      -DBUILD_PERF_TESTS=OFF
      -DBUILD_PNG=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_ZLIB=OFF
      -DBUILD_opencv_hdf=OFF
      -DBUILD_opencv_java=OFF
      -DBUILD_opencv_text=OFF
      -DOPENCV_ENABLE_NONFREE=ON
      -DOPENCV_EXTRA_MODULES_PATH=#{buildpath}/opencv_contrib/modules
      -DWITH_1394=OFF
      -DWITH_CUDA=OFF
      -DWITH_EIGEN=ON
      -DWITH_FFMPEG=ON
      -DWITH_GPHOTO2=OFF
      -DWITH_GSTREAMER=OFF
      -DWITH_JASPER=OFF
      -DWITH_OPENEXR=ON
      -DWITH_OPENGL=OFF
      -DWITH_QT=OFF
      -DWITH_TBB=ON
      -DWITH_VTK=OFF
      -DBUILD_opencv_python2=OFF
      -DBUILD_opencv_python3=ON
      -DPYTHON3_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
    ]

    if Hardware::CPU.intel?
      args << "-DENABLE_AVX=OFF" << "-DENABLE_AVX2=OFF"
      args << "-DENABLE_SSE41=OFF" << "-DENABLE_SSE42=OFF" unless MacOS.version.requires_sse42?
    end

    mkdir "build" do
      system "cmake", "..", *args
      inreplace "modules/core/version_string.inc", "#{HOMEBREW_SHIMS_PATH}/mac/super/", ""
      system "make"
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
      inreplace "modules/core/version_string.inc", "#{HOMEBREW_SHIMS_PATH}/mac/super/", ""
      system "make"
      lib.install Dir["lib/*.a"]
      lib.install Dir["3rdparty/**/*.a"]
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <opencv/cv.h>
      #include <iostream>
      int main() {
        std::cout << CV_VERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal `./test`.strip, version.to_s

    py3_version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{py3_version}/site-packages"
    output = shell_output(Formula["python@3.9"].opt_bin/"python3 -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end
