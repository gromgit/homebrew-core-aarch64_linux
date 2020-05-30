class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/3.36/evince-3.36.3.tar.xz"
  sha256 "af2ebdf7f74e6580c4f1a12bdfe26b9ff90374d7acae061de0666d64012a9db2"

  bottle do
    sha256 "4e5e551699ebe6edf399a9d6e0a54cabbe9484cdaa39f7e7f96409099af2abfc" => :catalina
    sha256 "c3715dfbd8e02f0e94a08768815cd65516b245e5bbf1be02d08fce57497bc365" => :mojave
    sha256 "19df80d484b25909c0ff6c71c7cf19fcf27b1ed681746e6ac041e46ad30f5171" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "djvulibre"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libarchive"
  depends_on "libgxps"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "python@3.8"

  def install
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dnautilus=false
      -Ddjvu=enabled
      -Dgxps=enabled
      -Dcomics=enabled
      -Dgtk_doc=false
      -Dintrospection=true
      -Dbrowser_plugin=false
      -Dgspell=enabled
      -Ddbus=false
    ]

    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end
