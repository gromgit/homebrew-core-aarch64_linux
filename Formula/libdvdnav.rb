class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdnav/6.1.1/libdvdnav-6.1.1.tar.bz2"
  sha256 "c191a7475947d323ff7680cf92c0fb1be8237701885f37656c64d04e98d18d48"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8ac6345b54ddac3d399fc3fa22911f1127b3d6130cd223c59158c075e990a00c"
    sha256 cellar: :any, big_sur:       "c95ff0063f69997b0041d1bc4fd31a517eeb131a9bf92f549feb7fc07606ea23"
    sha256 cellar: :any, catalina:      "e20bd00c923e4e837a1eac6f89933377afd17957be74a175734d7896efceb27a"
    sha256 cellar: :any, mojave:        "6c13d8aa2220232e9a0e5317371bd52909ec55b0bb08ed7b591612b60814dc7a"
    sha256 cellar: :any, high_sierra:   "a9c90f8109ce908ffc4fc0b6972ff4869638de8f52787bedd2c471ce457e1edf"
  end

  head do
    url "https://code.videolan.org/videolan/libdvdnav.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libdvdread"

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
