class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.5.tar.gz"
  sha256 "56b978faaeb8b2896032bd604d03c3501002187eef1ca58ceced40f11a65dc0e"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "54469e98b53d284cd45667fcaa90c97288c5b086e9fd3d389a6057caf94c8caa" => :big_sur
    sha256 "00d02729c640d211d25f84a47606c99464fe6c649936566fbfffe1ac7436c7a3" => :catalina
    sha256 "7bbc703b670c5b5555c562fa9e52eabfd0cfdc0b379e9559e9d9c5c95499fe8b" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build

  depends_on "dos2unix"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "giflib"
  depends_on "gtk+3" if build.head?
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libnet"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"
  depends_on "sdl2" unless build.head?
  depends_on "sdl2_image"
  depends_on "xz"

  def install
    configure_flags = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-arch
      --disable-pdf-docs
      --enable-external-ffmpeg
    ]

    configure_flags << if build.head?
      "--enable-native-gtk3ui"
    else
      "--enable-sdlui2"
    end

    system "./autogen.sh"
    system "./configure", *configure_flags
    system "make", "install"
  end

  def caveats
    <<~EOS
      App bundles are no longer built for each emulator. The binaries are
      available in #{HOMEBREW_PREFIX}/bin directly instead.
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/petcat -help", 1)
  end
end
