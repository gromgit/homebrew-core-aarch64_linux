class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/3.36/gtranslator-3.36.0.tar.xz"
  sha256 "2daa1d3b59b4a35ef54df087345b03e1703e725081f9dac543539228a715add3"
  revision 2

  bottle do
    sha256 "e547ff769ad7373b828c2684ebbebb65cc5213ccdea43b536f2a148f54ce7966" => :catalina
    sha256 "48af749ea70eda5384fb5868ae553caea6556ee257ea67de9ba0a1860b426325" => :mojave
    sha256 "4786e9fd15937b7a4601082799c7dde0e9562d3eac05210a6b404a02b9378755" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "iso-codes"
  depends_on "itstool"
  depends_on "json-glib"
  depends_on "libdazzle"
  depends_on "libgda"
  depends_on "libsoup"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/gtranslator", "-h"
  end
end
