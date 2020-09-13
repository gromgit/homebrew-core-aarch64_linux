class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.38/yelp-tools-3.38.0.tar.xz"
  sha256 "607ce4b3ee8517c42db924a01a78660a03317595c75825731ea86a920e2b04b0"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fd04fbc43832ca6a6e75ffcd928794c866153c7cf04d4f366e79d15a14a317b6" => :catalina
    sha256 "fd04fbc43832ca6a6e75ffcd928794c866153c7cf04d4f366e79d15a14a317b6" => :mojave
    sha256 "fd04fbc43832ca6a6e75ffcd928794c866153c7cf04d4f366e79d15a14a317b6" => :high_sierra
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/3.38/yelp-xsl-3.38.0.tar.xz"
    sha256 "13bcc2011c4c55384174d18c7b2f0015a96b04efd24f3f646af2e7167e7ab0d7"
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
