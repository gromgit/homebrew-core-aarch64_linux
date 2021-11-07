class Bitwise < Formula
  desc "Terminal based bit manipulator in ncurses"
  homepage "https://github.com/mellowcandle/bitwise"
  url "https://github.com/mellowcandle/bitwise/releases/download/v0.43/bitwise-v0.43.tar.gz"
  sha256 "f524f794188a10defc4df673d8cf0b3739f93e58e93aff0cdb8a99fbdcca2ffb"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "12bd8782a95065a4cce3ca9e91ae5c838652da9e84bce26813845fc9f7058aee"
    sha256 cellar: :any,                 arm64_big_sur:  "4301045752db45352b2f1554ae015a8263e77dea15d724aeb0d8a7bb3b78f1db"
    sha256 cellar: :any,                 monterey:       "a29944fc1f2e5e1aeedfada3b8510abd24c5b3095324c562a7d2f5fd084026c2"
    sha256 cellar: :any,                 big_sur:        "ee1f6edfdc4b538a0017253af270a94fc28da00bdac5754efcef42ed8718e1dc"
    sha256 cellar: :any,                 catalina:       "0f6da9c52d7e2185dc61708d5bdda296708d4bd398c525e01a699eaf58feac21"
    sha256 cellar: :any,                 mojave:         "9844d7c02e06929bd6060454f93ccb115186f1f3418c3d4f1a93f2a0764ec0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "962189cb81bb6f94faa36609171829fed77481e21119fc93ee3e94bde82493bc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    assert_match "0 0 1 0 1 0 0 1", shell_output("#{bin}/bitwise --no-color '0x29A >> 4'")
  end
end
