class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.8.0.tar.gz"
  sha256 "756ce2c6241b2104dc19097488225de559ac1802a175be0233cfb6fbc02f3bd2"
  license "GPL-2.0"
  revision 5
  head "https://github.com/cmus/cmus.git"

  bottle do
    sha256 "996682e532cf6e402b37ce42807eb876703db84f2b73c019ce0180052cbf21cc" => :big_sur
    sha256 "63e046f82a65d23949d3c147ca484490aee9f41eb75bec24178c9ebf0928a02a" => :catalina
    sha256 "87ae24805f1363afd8f409c05fd9b2b684c599838e40f4a7e1bb5f0ef1264c7d" => :mojave
    sha256 "d11dc1c6d34f9caf2cfd0de6893d14013a4e2e50f9414598603ca55d91198b2c" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libcue"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mp4v2"
  depends_on "opusfile"

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}",
                          "CONFIG_WAVPACK=n", "CONFIG_MPC=n"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
