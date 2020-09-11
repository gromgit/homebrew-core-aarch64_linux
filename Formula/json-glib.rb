class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://wiki.gnome.org/Projects/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.6/json-glib-1.6.0.tar.xz"
  sha256 "0d7c67602c4161ea7070fab6c5823afd9bd7f7bc955f652a50d3753b08494e73"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "643ce68e84c094e77597f2f1b83678d3675b74b1a2e11c43804290d30fa456e6" => :catalina
    sha256 "223b5472cc71a1eea8efc818d66fa8e6ff05a4aff45d60d4deccba54f82d39dd" => :mojave
    sha256 "ad30f6f204dd27504d70e9ac22dcfdd482975a5e97879c0b4095527bde68d985" => :high_sierra
    sha256 "08dbbf2bcef7fdeccfbcd7a0391c4eafa67f914ba0f021c8a41298a6359f7c24" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dintrospection=enabled", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <json-glib/json-glib.h>

      int main(int argc, char *argv[]) {
        JsonParser *parser = json_parser_new();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/json-glib-1.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
