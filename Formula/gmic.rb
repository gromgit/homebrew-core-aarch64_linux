class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.8.1.tar.gz"
  sha256 "1a2b4c75c428201e52e920bd07e6c04118ae294cb89fce3c1c4ef386421b2a7a"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "d259d87c9472d9e46b898938d6e14136eea816c20b9a367f5c6a8a5388e49e05" => :catalina
    sha256 "10f8571f1376aec45f91b45c1ed57b23cf07ef1c73dc944c22ae5db5048a0d68" => :mojave
    sha256 "654703f48c73f2e7977bff37b2357ad2a0d4a67d4b0c41877833c7a5bf7eb632" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    system "cmake", *std_cmake_args,
                    "-DENABLE_FFMPEG=OFF",
                    "-DENABLE_OPENCV=OFF",
                    "-DENABLE_OPENEXR=OFF",
                    "-DENABLE_X=OFF"
    system "make", "install"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
  end
end
