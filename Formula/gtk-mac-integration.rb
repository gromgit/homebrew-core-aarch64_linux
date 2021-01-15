class GtkMacIntegration < Formula
  desc "Integrates GTK macOS applications with the Mac desktop"
  homepage "https://wiki.gnome.org/Projects/GTK+/OSX/Integration"
  url "https://download.gnome.org/sources/gtk-mac-integration/3.0/gtk-mac-integration-3.0.0.tar.xz"
  sha256 "af88bb3a284e24c550e15290e07e562fcd2a038ebb0fcc863dd069d3738952ae"
  license "LGPL-2.1-only"

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
    url "https://gitlab.gnome.org/GNOME/gtk-mac-integration.git"
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
