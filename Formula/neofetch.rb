class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/7.1.0.tar.gz"
  sha256 "58a95e6b714e41efc804eca389a223309169b2def35e57fa934482a6b47c27e7"
  license "MIT"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfb4c9f42eee7659b0028a7d4de28524d5a6eb8f1199f83789fa0242b37c456e" => :catalina
    sha256 "bfb4c9f42eee7659b0028a7d4de28524d5a6eb8f1199f83789fa0242b37c456e" => :mojave
    sha256 "bfb4c9f42eee7659b0028a7d4de28524d5a6eb8f1199f83789fa0242b37c456e" => :high_sierra
  end

  depends_on "imagemagick"
  depends_on "screenresolution"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end
