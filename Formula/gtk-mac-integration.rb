class GtkMacIntegration < Formula
  desc "Integrates GTK macOS applications with the Mac desktop"
  homepage "https://wiki.gnome.org/Projects/GTK+/OSX/Integration"
  url "https://download.gnome.org/sources/gtk-mac-integration/2.1/gtk-mac-integration-2.1.3.tar.xz"
  sha256 "d5f72302daad1f517932194d72967a32e72ed8177cfa38aaf64f0a80564ce454"
  license "LGPL-2.1-only"
  revision 6

  # We use a common regex because gtk-mac-integration doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-mac-integration[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "691c07cfd431e5388935a3b281b815f13cc3e7be8280962f88dfe86b5d2304b3" => :big_sur
    sha256 "ef5a2b5f7fe43e02983c1ef32d1de720fdcfa5db08cb7ecb87ff06d14836dfdb" => :arm64_big_sur
    sha256 "2fc4360143f0dc7464d4aded53ce3ba32bf08a094cffbcb431c748eb50a235ba" => :catalina
    sha256 "36d524103f6ee6062af215b2fff733b950453a4b9c4d8f6e2f32451fc73d1d8b" => :mojave
  end

  head do
    url "https://github.com/jralls/gtk-mac-integration.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"
  depends_on "gtk+3"

  patch :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-gtk2
      --with-gtk3
      --enable-introspection=yes
      --enable-python=no
    ]

    system "./autogen.sh", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtkosxapplication.h>

      int main(int argc, char *argv[]) {
        gchar *bundle = gtkosx_application_get_bundle_path();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gtkmacintegration
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -DMAC_INTEGRATION
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lgtkmacintegration-gtk2
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/src/Makefile.am b/src/Makefile.am
index 3180e5e..2915df5 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -13,11 +13,7 @@ SOURCES = \
 	cocoa_menu_item.c				\
 	gtkosxapplication_quartz.c		\
 	gtkosxapplication.c				\
-	gtkosx-image.c					\
-	gtk-mac-dock.c					\
-	gtk-mac-bundle.c				\
-	gtk-mac-menu.c					\
-	gtk-mac-image-utils.c
+	gtkosx-image.c

 HEADER = \
 	cocoa_menu.h              \
@@ -26,12 +22,6 @@ HEADER = \
 	GNSMenuBar.h              \
 	GNSMenuDelegate.h         \
 	GNSMenuItem.h             \
-	gtk-mac-bundle.h          \
-	gtk-mac-dock.h            \
-	gtk-mac-image-utils.h     \
-	gtk-mac-integration.h     \
-	gtk-mac-menu.h            \
-	gtk-mac-private.h         \
 	GtkApplicationDelegate.h  \
 	GtkApplicationNotify.h    \
 	gtkosx-image.h            \
@@ -45,7 +35,7 @@ libgtkmacintegration_gtk3_la_SOURCES = $(SOURCES)
 libgtkmacintegration_gtk3_la_CFLAGS = $(GTK3_CFLAGS) -xobjective-c
 libgtkmacintegration_gtk3_la_OBJCFLAGS = $(GTK3_CFLAGS)
 libgtkmacintegration_gtk3_la_LIBADD =  $(GTK3_LIBS) -lobjc
-libgtkmacintegration_gtk3_la_LDFLAGS = -framework Carbon -framework ApplicationServices -version-info $(GTK_MAC_INTEGRATION_LT_VERSION)
+libgtkmacintegration_gtk3_la_LDFLAGS = -framework ApplicationServices -version-info $(GTK_MAC_INTEGRATION_LT_VERSION)
 endif
 if WITH_GTK2
 lib_LTLIBRARIES += libgtkmacintegration-gtk2.la
@@ -53,16 +43,12 @@ libgtkmacintegration_gtk2_la_SOURCES = $(SOURCES)
 libgtkmacintegration_gtk2_la_CFLAGS = $(GTK2_CFLAGS) -xobjective-c
 libgtkmacintegration_gtk2_la_OBJCFLAGS = $(GTK2_CFLAGS)
 libgtkmacintegration_gtk2_la_LIBADD = $(GTK2_LIBS) -lobjc
-libgtkmacintegration_gtk2_la_LDFLAGS = -framework Carbon -framework ApplicationServices -version-info $(GTK_MAC_INTEGRATION_LT_VERSION)
+libgtkmacintegration_gtk2_la_LDFLAGS = -framework ApplicationServices -version-info $(GTK_MAC_INTEGRATION_LT_VERSION)
 endif

 integration_includedir = $(includedir)/gtkmacintegration
 integration_include_HEADERS =				\
-	gtk-mac-integration.h				\
-	gtkosxapplication.h				\
-	gtk-mac-menu.h					\
-	gtk-mac-dock.h					\
-	gtk-mac-bundle.h
+	gtkosxapplication.h

 noinst_PROGRAMS =
 test_integration_gtk3_CFLAGS =

