class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.6.2.1/easyrpg-player-0.6.2.1.tar.xz"
  sha256 "681b7df9546f3fee52658d4262e295a8433d6a9bb9f1cd7597196f1015326ba9"

  bottle do
    cellar :any
    sha256 "42e4f4c9bfb0976b86352945add0129be8945e72a46ab83b1d0fa1ad78d1aa1e" => :catalina
    sha256 "48697f536c393274f96fde667afc03e59aa0d753b94bf7aa4f671c81cbc16d84" => :mojave
    sha256 "12bff4afc0b160b939e27a9d78a00c94116f29984816d85f26e3423ad47d2562" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "pixman"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "speexdsp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /EasyRPG Player #{version}$/, shell_output("#{bin}/easyrpg-player -v")
  end
end
