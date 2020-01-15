class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.8.2.tar.gz"
  sha256 "09173c157a248d4c2c40b6250ae1058f1518665eedfb9f971ed1045fe652daea"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "31bbe3c7311ae6b5e4967598d01ecf0c0fb5ed9ba526fda5aed656bf60d94f24" => :catalina
    sha256 "e43ec1065738356f302f176355dfa2c4d4ef2a6c4dc8526efe3c48444a251602" => :mojave
    sha256 "eeb4d125878e7c3aaa1d0b9b831e69f88e1f1accd36c18de8679b6d2038f5ed9" => :high_sierra
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
