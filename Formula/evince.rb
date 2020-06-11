class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/3.36/evince-3.36.5.tar.xz"
  sha256 "6f0dd6e30639eb620f201a6ae40f21c4b78c030f0d6437f9e309f7240195e97c"

  bottle do
    sha256 "71cb3fec5fea0f1d45a05bd23409064bf2e84fbca39a2aefa99413f454bbdde5" => :catalina
    sha256 "ec0a82ff4287fe5fb1e54c7583026332ce2b55e0c83c256bc3491ee78be20237" => :mojave
    sha256 "88d4b18e0524341968271c580e850c4cb56514b2ea004c8437871d4b5eb34c13" => :high_sierra
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
