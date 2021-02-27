class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v5/nano-5.6.tar.xz"
  sha256 "fce183e4a7034d07d219c79aa2f579005d1fd49f156db6e50f53543a87637a32"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "483201d930bd0dbc8ec1306a2a72f3a4b353cd875dc84ca585c6119939569700"
    sha256 big_sur:       "0da5a7589ec71f4c8d59030e9e8bed2a15573745af0df2cac3bedb43f83bfb44"
    sha256 catalina:      "1043c2ec91e1c5be6f99672265629b2bb25591b912431856ccbf0077cac70071"
    sha256 mojave:        "78cea136117347b66632767629a1f7744f763ee750a7b578250a0c2381d8b007"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
