class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "99ea217643c506afce2cb5c9aa8cbc0848669677b3236815acb823fd7fcce3fa"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "670670842d9fe726b5fc55488c1bc11af3106add82392d7845cd0056b1140247"
    sha256 cellar: :any, big_sur:       "24fec2b17beb4c38c366750e1e609beabd992d322ed702ccc8e8b4fc979d309d"
    sha256 cellar: :any, catalina:      "ac40a8afc0d08e6283a421fd00edf5462c682d3e4ba987a3da78b3e94b38d7a8"
    sha256 cellar: :any, mojave:        "a96a6abf016caaaafc4e4ddddfafef05e95de772d910ac7eb24098b4ef9c1834"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "graphicsmagick"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "openslide"
  depends_on "webp"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/timg", "--version"
    system "#{bin}/timg", "-g10x10", test_fixtures("test.gif")
    system "#{bin}/timg", "-g10x10", test_fixtures("test.png")
    system "#{bin}/timg", "-pq", "-g10x10", "-o", testpath/"test-output.txt", test_fixtures("test.jpg")
    assert_match "38;2;255;38;0;49m", (testpath/"test-output.txt").read
  end
end
