class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v5/nano-5.5.tar.xz"
  sha256 "390b81bf9b41ff736db997aede4d1f60b4453fbd75a519a4ddb645f6fd687e4a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "ac9aba47448b4561e8c2fecc2fbc9504952e3e3c39506dba7844b2c61ffbb149" => :big_sur
    sha256 "ca3b7ef1d7422a7d019d8e8299fd07a20d0332941940ebdb37a02ae45538d773" => :arm64_big_sur
    sha256 "2f7dab76ce57ceba10c3c8527ea68e5f060b5b8871128a170585175899a0eb87" => :catalina
    sha256 "ed3c326161300b01b3f83f44a51749e665fc129eae8bbf2bc150bee10bc1ec05" => :mojave
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
