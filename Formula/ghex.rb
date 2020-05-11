class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/3.18/ghex-3.18.4.tar.xz"
  sha256 "c2d9c191ff5bce836618779865bee4059db81a3a0dff38bda3cc7a9e729637c0"
  revision 2

  bottle do
    sha256 "d19110bde790ffb5c9c07b7d4f836a40bde24524103ad0630e0e15041058e6c9" => :catalina
    sha256 "6fee2b13fdf3c3f9eafbf92d6cd1cae208f5a1444e02b9c438e31e1333a02497" => :mojave
    sha256 "429217a3f63b5c6a04e468390442a3ffb304d54c58c356191d93984ba097a0b8" => :high_sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"

  # submitted upstream as https://gitlab.gnome.org/GNOME/ghex/merge_requests/8
  patch :DATA

  def install
    # ensure that we don't run the meson post install script
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
    system "#{bin}/ghex", "--help"
  end
end

__END__
diff --git a/src/meson.build b/src/meson.build
index fdcdcc2..ac45c93 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -23,9 +23,9 @@ libghex_c_args = [
   '-DG_LOG_DOMAIN="libgtkhex-3"'
 ]

-libghex_link_args = [
+libghex_link_args = cc.get_supported_link_arguments([
   '-Wl,--no-undefined'
-]
+])

 install_headers(
   libghex_headers,
@@ -36,6 +36,7 @@ libghex = library(
   'gtkhex-@0@'.format(libghex_version_major),
   libghex_sources + libghex_headers,
   version: '0.0.0',
+  darwin_versions: ['1', '1.0'],
   include_directories: ghex_root_dir,
   dependencies: libghex_deps,
   c_args: libghex_c_args,
