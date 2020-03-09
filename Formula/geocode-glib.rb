class GeocodeGlib < Formula
  desc "GNOME library for gecoding and reverse geocoding"
  homepage "https://developer.gnome.org/geocode-glib"
  url "https://download.gnome.org/sources/geocode-glib/3.26/geocode-glib-3.26.2.tar.xz"
  sha256 "01fe84cfa0be50c6e401147a2bc5e2f1574326e2293b55c69879be3e82030fd1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c820f7a59a67873f06b17fa6bb9b67c1bc2413f969a9ec1c2b403fe50fc81fb1" => :catalina
    sha256 "eb925bc4c5d4282f30a1eebda10de28309786f57e9b41c12e2805ea0f84a84f1" => :mojave
    sha256 "e399aaff2c1f8c4490c2b592244e0ef5896772f6809cebddfe64d69a0bf7a4ed" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libsoup"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Denable-installed-tests=false", "-Denable-gtk-doc=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/gnome"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <geocode-glib/geocode-glib.h>

      int main(int argc, char *argv[]) {
        GeocodeLocation *loc = geocode_location_new(1.0, 1.0, 1.0);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/geocode-glib-1.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgeocode-glib
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
