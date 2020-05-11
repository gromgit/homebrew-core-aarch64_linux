class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.10/graphene-1.10.0.tar.xz"
  sha256 "406d97f51dd4ca61e91f84666a00c3e976d3e667cd248b76d92fdb35ce876499"
  revision 2

  bottle do
    cellar :any
    sha256 "311714c109289ca8e7482597caaec84560c04a09bb72eee16321e59245b0b7d1" => :catalina
    sha256 "709d0e1fd062908d9ffb2a3e827090fe293b1483c91ae147d46b28d5b0913e4b" => :mojave
    sha256 "314c03ef076f4e2c07ac9213790e19601f83a069b86970c4643a5e340c946d90" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <graphene-gobject.h>

      int main(int argc, char *argv[]) {
      GType type = graphene_point_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/graphene-1.0
      -I#{lib}/graphene-1.0/include
      -L#{lib}
      -lgraphene-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
