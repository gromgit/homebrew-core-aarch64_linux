class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.8.1.tar.gz"
  sha256 "1a2b4c75c428201e52e920bd07e6c04118ae294cb89fce3c1c4ef386421b2a7a"
  revision 1
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "da9fc934874c4f012dfb5d71d43c2d67374f39703d31a0b7e0a51dd3bab733b2" => :catalina
    sha256 "56a0521cabc09e0a28ddb6e79e14405d8de25b7728c049a79cb4a3addf22d1c6" => :mojave
    sha256 "8b269ac75b7d81b9e37bf3352ed9ccd7488d078f6aa1b4fe00f4f599a40130a9" => :high_sierra
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
