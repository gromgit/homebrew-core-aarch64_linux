class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.0/hamlib-4.0.tar.gz"
  sha256 "1fa24d4a8397b29a29f39be49c9042884d524b7a584ea8852bd770bd658d66f2"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git"

  bottle do
    cellar :any
    sha256 "bb9d73c8ec45bf3a4274b8262bc2d15dcb0863cf9fcc0274d0103d600420dc1a" => :big_sur
    sha256 "a63c4253d798367507e46096c4d4f92e3026e086f116d364f298e7909a986fb6" => :catalina
    sha256 "2d82d6ba8bf5197285d0262ab556a5d344d244b8118b6e27b51dbd503d3c618b" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
