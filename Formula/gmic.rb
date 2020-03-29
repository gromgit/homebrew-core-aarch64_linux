class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.9.0.tar.gz"
  sha256 "6233695f9b27999dcc7cc3aa7480b0f192bd44de85209091a3b4b8a65ae8c4b5"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "a345d7fa1d3b10d213a47fdc852eebda078398b2b08941b67df2bb118a1b2d02" => :catalina
    sha256 "ae75a74723fa3be4de55a2a24cffa546c0ecbb3db889f4316cb39eed01f4ffd9" => :mojave
    sha256 "b26d3ce1f76cdaaba61ceb2bd76c237a399b4bd448b1d7d46602516ed61a8a92" => :high_sierra
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
    system bin/"gmic", "-input", test_fixtures("test.jpg"), "rodilius", "10,4,400,16",
           "smooth", "60,0,1,1,4", "normalize_local", "10,16", "-output", testpath/"test_rodilius.jpg"
    assert_predicate testpath/"test_rodilius.jpg", :exist?
  end
end
