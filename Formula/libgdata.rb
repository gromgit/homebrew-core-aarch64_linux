class Libgdata < Formula
  desc "GLib-based library for accessing online service APIs"
  homepage "https://wiki.gnome.org/Projects/libgdata"
  url "https://download.gnome.org/sources/libgdata/0.18/libgdata-0.18.0.tar.xz"
  sha256 "f0c20112fa5372b62c01256f268aef5131a161dfc23868f393ecf7b8b3752580"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "e31807a39d967829c44e6fb94a2d3efba07e3e6fc8ae80747e18b435f46ed15f"
    sha256 big_sur:       "acf37716c065ba69fc22c35236bfc7ebdb7b01623e20ce82ec03306c2684b925"
    sha256 catalina:      "c93f83c348b673c9768be22ae9e1119d5eb86ff94bd28e95976c2dca47f5defe"
    sha256 mojave:        "e84e22686408f68d77b239d0cdc476f33e677f8aa66405ba4506513e31eafe2c"
    sha256 high_sierra:   "0320d28747a36cf8451eff40a16bc25c9735e287888177c2c1f1ec93a835cf56"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "liboauth"
  depends_on "libsoup"

  def install
    mkdir "build" do
      system "meson", *std_meson_args,
        "-Dintrospection=true",
        "-Doauth1=enabled",
        "-Dalways_build_tests=false",
        "-Dvapi=true",
        "-Dgtk=enabled",
        "-Dgoa=disabled",
        "-Dgnome=disabled",
        ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdata/gdata.h>

      int main(int argc, char *argv[]) {
        GType type = gdata_comment_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    json_glib = Formula["json-glib"]
    liboauth = Formula["liboauth"]
    libsoup = Formula["libsoup"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libgdata
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{liboauth.opt_include}
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{MacOS.sdk_path}/usr/include/libxml2
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{libsoup.opt_lib}
      -L#{lib}
      -lgdata
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
      -lsoup-2.4
      -lxml2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
