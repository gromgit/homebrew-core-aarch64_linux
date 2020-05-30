class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/3.36/evince-3.36.2.tar.xz"
  sha256 "34c3ce22fda0d08d61e2a3aee0d1e1117879d5fea6ff9acf67f5b0632359b608"

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

  # Patch submitted upstream at https://gitlab.gnome.org/GNOME/evince/-/merge_requests/245
  patch :DATA

  def install
    ENV["DESTDIR"] = "/"

    args = %w[
      --buildtype=release
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

__END__
diff --git a/backend/comics/meson.build b/backend/comics/meson.build
index 66b73a9..f1a80ca 100644
--- a/backend/comics/meson.build
+++ b/backend/comics/meson.build
@@ -20,6 +20,7 @@ shared_module(
   link_depends: backends_symbol_map,
   install: true,
   install_dir: ev_backendsdir,
+  name_suffix: name_suffix,
 )

 test_name = 'test-ev-archive'
diff --git a/backend/djvu/meson.build b/backend/djvu/meson.build
index 604450c..b532897 100644
--- a/backend/djvu/meson.build
+++ b/backend/djvu/meson.build
@@ -14,4 +14,5 @@ shared_module(
   link_depends: backends_symbol_map,
   install: true,
   install_dir: ev_backendsdir,
+  name_suffix: name_suffix,
 )
diff --git a/backend/dvi/meson.build b/backend/dvi/meson.build
index 9f65936..c3bea84 100644
--- a/backend/dvi/meson.build
+++ b/backend/dvi/meson.build
@@ -24,4 +24,5 @@ shared_module(
   link_depends: backends_symbol_map,
   install: true,
   install_dir: ev_backendsdir,
+  name_suffix: name_suffix,
 )
diff --git a/backend/pdf/meson.build b/backend/pdf/meson.build
index b1f3be4..f89fce2 100644
--- a/backend/pdf/meson.build
+++ b/backend/pdf/meson.build
@@ -15,4 +15,5 @@ shared_module(
   link_depends: backends_symbol_map,
   install: true,
   install_dir: ev_backendsdir,
+  name_suffix: name_suffix,
 )
diff --git a/backend/ps/meson.build b/backend/ps/meson.build
index 3569bd1..109cb52 100644
--- a/backend/ps/meson.build
+++ b/backend/ps/meson.build
@@ -8,4 +8,5 @@ shared_module(
   link_depends: backends_symbol_map,
   install: true,
   install_dir: ev_backendsdir,
+  name_suffix: name_suffix,
 )
diff --git a/backend/tiff/meson.build b/backend/tiff/meson.build
index b33cc1d..bb14a1d 100644
--- a/backend/tiff/meson.build
+++ b/backend/tiff/meson.build
@@ -13,4 +13,5 @@ shared_module(
   link_depends: backends_symbol_map,
   install: true,
   install_dir: ev_backendsdir,
+  name_suffix: name_suffix,
 )
diff --git a/backend/xps/meson.build b/backend/xps/meson.build
index 6306599..361ac7b 100644
--- a/backend/xps/meson.build
+++ b/backend/xps/meson.build
@@ -8,4 +8,5 @@ shared_module(
   link_depends: backends_symbol_map,
   install: true,
   install_dir: ev_backendsdir,
+  name_suffix: name_suffix,
 )
diff --git a/browser-plugin/meson.build b/browser-plugin/meson.build
index af1dc69..84d0311 100644
--- a/browser-plugin/meson.build
+++ b/browser-plugin/meson.build
@@ -52,4 +52,5 @@ shared_module(
   cpp_args: cppflags,
   install: true,
   install_dir: browser_plugin_dir,
+  name_suffix: name_suffix,
 )
diff --git a/meson.build b/meson.build
index 50f778d..b530758 100644
--- a/meson.build
+++ b/meson.build
@@ -429,6 +429,13 @@ endif
 mime_types_conf = configuration_data()
 mime_types_conf.set('EVINCE_MIME_TYPES', ';'.join(evince_mime_types))

+# GLib on macOS expects so as shared_module suffix, while meson uses dylib by default
+if host_machine.system() == 'darwin'
+  name_suffix = 'so'
+else
+  name_suffix = []
+endif
+
 subdir('cut-n-paste')
 subdir('libdocument')
 subdir('backend')
diff --git a/properties/meson.build b/properties/meson.build
index cd64dde..50e65be 100644
--- a/properties/meson.build
+++ b/properties/meson.build
@@ -25,5 +25,6 @@ if enable_nautilus
     link_with: libevproperties,
     install: true,
     install_dir: nautilus_extension_dir,
+    name_suffix: name_suffix,
   )
 endif

