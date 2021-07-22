class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/0.13.0.tar.gz"
  sha256 "1d51c1d918493761a1d702e6f9bf46409b9ecd0ea98ca4081fc41d355957222a"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "2f91d8a55a3b5267771691f5008340ff41acb8f60e3e1be6756f60a2b60e92df"
    sha256 big_sur:       "43a8733426df8a9ec7fc219f44610c2a69f9d0477afb829c860e5feeb6cf33b2"
    sha256 catalina:      "ff7b85e5cd1c7eefaa75b095b6a193453c126113485fb865640c0c671d7c3793"
    sha256 mojave:        "df1a35102836900f1891cd5935c82f42df02ef3e60ed49d03c471981a919571f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.9"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  def install
    args = std_cmake_args
    args << "-DCDOGS_DATA_DIR=#{pkgshare}/"
    system "cmake", ".", *args
    system "make"
    bin.install %w[src/cdogs-sdl src/cdogs-sdl-editor]
    pkgshare.install %w[data dogfights graphics missions music sounds]
    doc.install Dir["doc/*"]
  end

  test do
    pid = fork do
      exec bin/"cdogs-sdl"
    end
    sleep 7
    assert_predicate testpath/".config/cdogs-sdl",
                     :exist?, "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end
