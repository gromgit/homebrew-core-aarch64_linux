class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.48.tar.xz"
  sha256 "57cce33a41d34db81292e9eebae8b5046f30e5d919d848256fbb75bfc132a590"
  license ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256 "cd2ea956e97d9a0b4cca6b1fc8438960211c2d4b6330062d38534c6415e7a971" => :catalina
    sha256 "c9ab0149387a0624e2cde10decc20a4c0b7910819ea5b5876ae84a741108f58d" => :mojave
    sha256 "b96a7352a602b4a3bcc35e4727f87eb620be31e59eaafb8aa9fe63b91f903508" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gettext"
  depends_on "goffice"
  depends_on "itstool"
  depends_on "libxml2"
  depends_on "rarian"

  def install
    # ensures that the files remain within the keg
    inreplace "component/Makefile.in",
              "GOFFICE_PLUGINS_DIR = @GOFFICE_PLUGINS_DIR@",
              "GOFFICE_PLUGINS_DIR = @libdir@/goffice/@GOFFICE_API_VER@/plugins/gnumeric"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gnumeric", "--version"
  end
end
