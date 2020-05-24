class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v4/nano-4.9.3.tar.xz"
  sha256 "6e3438f033a0ed07d3d74c30d0803cbda3d2366ba1601b7bbf9b16ac371f51b4"

  bottle do
    sha256 "0ddfd95328a4d8be2677a8f42a01528d719af912b92df30f6004749586c235df" => :catalina
    sha256 "d012caaefc2cb8fe4dce0dc8a3aab52e43dbb14befa82ba157916f49df008164" => :mojave
    sha256 "c7dbcf7a8f17bc9457434656ca10b6e42136d997d25a47f9fa06830a418ea17e" => :high_sierra
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
