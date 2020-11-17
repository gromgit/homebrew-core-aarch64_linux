class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.9.3.tar.gz"
  sha256 "46177ef6612be56574eafa1b428636fe1c7388211cc852a9e0575bce3ccf43de"
  license "CECILL-2.1"
  head "https://github.com/dtschump/gmic.git"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "212cfa59e5e565b2895d8d7fe0969644de6a1f51a5396e86a18ae3ef1166a756" => :big_sur
    sha256 "b45430d5008003d4068a6e5f1cf57588daa2c63ed41a550f5e7617abe0d83414" => :catalina
    sha256 "f075afe5e1dbbed37dfd6cf1262301a927a0add9cab5942bce4458a2718e65ac" => :mojave
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
