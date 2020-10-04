class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.38/yelp-tools-3.38.0.tar.xz"
  sha256 "607ce4b3ee8517c42db924a01a78660a03317595c75825731ea86a920e2b04b0"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "74682c7165e489fcc0b4c5134dfb38e91a1c1416da4172fbd71af2437defeed0" => :catalina
    sha256 "860e65ac76a6f80aaa6426a8c9cb6df1c6182381d918e0bad34045f4948d0463" => :mojave
    sha256 "f2c62eebb9eab64483ac42b4d085fe1eafa6816d5dd4c46115915b5d22ac2041" => :high_sierra
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/3.38/yelp-xsl-3.38.1.tar.xz"
    sha256 "b321563da6ab7fa8b989adaf1a91262059696316b4ddca2288fddcfed8dcdf67"
  end

  def install
    resource("yelp-xsl").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", "#{share}/pkgconfig"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache",
           "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/yelp-new", "task", "ducksinarow"
    system "#{bin}/yelp-build", "html", "ducksinarow.page"
    system "#{bin}/yelp-check", "validate", "ducksinarow.page"
  end
end
