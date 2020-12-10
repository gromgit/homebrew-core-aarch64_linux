class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.2.tar.xz"
  sha256 "afd07a6ae2af4733eb06e516cb607276ee084d1d30aa1cf0c3fd6e62f1d3a144"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "d9c557bc2f3161818fcf4701e7cc123bd6d2f85ff9e80df5976392de9102a737" => :catalina
    sha256 "e23ff51d2b5b9adaa44f5d851da94c836f68886bacc2cd739b30166a2ec04312" => :mojave
    sha256 "6b40bde3ba007a8b18451502bcf49841d8a3f75ec06a7d6a8e748f508e7dc1f9" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "xa" => :build
  depends_on "flac"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --without-x11
      --without-sdl
      --without-sdl2
      --without-desktop_file_install
    ]

    # Workaround for bad compiler version check: https://github.com/mywave82/opencubicplayer/issues/30
    inreplace "configure",
              "2.95.[2-9]|2.95.[2-9][-].*|3.[0-9]|3.[0-9].[0-9]|3.[0-9]|3.[0-9].[0-9]-*|4.*|5.*|6.*|7*|8*|9*|10*",
              "[1-9]*"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ocp", "--help"
  end
end
