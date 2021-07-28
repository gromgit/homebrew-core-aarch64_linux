class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.7.2/imlib2-1.7.2.tar.bz2"
  sha256 "525d4e318927471bde4520786dc2550b59ab88533848db2d75c60f5b4e5821a1"
  license "Imlib2"

  bottle do
    sha256 arm64_big_sur: "553507ca84f523f31621e855aa4c270e09117d24484be2137ac73b283ea045f9"
    sha256 big_sur:       "caeadbe3c97905ca987a80e644d6ac0c8bc303529bcf01f0394565ae3565fb44"
    sha256 catalina:      "f1d96b7da32949e3a4ff1c05af2eaee8169a98464f57531d21a27280cabb7646"
    sha256 mojave:        "f412177de8db8e6ca5ed8f5bb263206512beac41a5090023b53e4712f49488fc"
    sha256 x86_64_linux:  "2a381f3e43d6f08326a693954e888a1585711366360689753b869211aa1e87e5"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
      --without-id3
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
