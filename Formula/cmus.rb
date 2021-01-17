class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.9.0.tar.gz"
  sha256 "e7ea7f5ec52b991cf378a9caf19e479be16a165a5b26adca058de711e72ad2a0"
  license "GPL-2.0-or-later"
  head "https://github.com/cmus/cmus.git"

  bottle do
    sha256 "1077999cc7e6fdab9e0ed403d5c4b21bf67d9a4ccf2118807d25d36eae9835a6" => :big_sur
    sha256 "d4d1567d3a05c37d7f1764feac658bb48f96b008d01d28e2e14a332c76ce0062" => :arm64_big_sur
    sha256 "d4e22535e6cef5013bf8c2a8e02acbd3519a3f7d0293118acd4bd3949224f7a1" => :catalina
    sha256 "0d62c91d720131fb266305b5d91b3286572c867ef190bb5116ef9766534d3ca1" => :mojave
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
