class Gtk4 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/4.0/gtk-4.0.2.tar.xz"
  sha256 "626707ac6751426ed76fed49c5b2d052dfee45757ce3827088ba87ca7f1dbc84"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/gtk[._-](4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 "8eb6bf2d9aa0371b71eefd07436b3f4073141197d096aa5e334699d50e2222e2" => :big_sur
    sha256 "aed4f9db955e8895e416285d5dd74433e097f546eb9b10c2e646bc6045adfb34" => :arm64_big_sur
    sha256 "9416f5c808896268263d0a9756a46c41495a34b5592e18a334ec1ff5a5715013" => :catalina
    sha256 "f6627a73db97d14ca84186feb0e0b5d470c8651190356e525b3430302178e76d" => :mojave
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "sassc" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "hicolor-icon-theme"
  depends_on "libepoxy"
  depends_on "pango"

  uses_from_macos "libxslt" => :build # for xsltproc

  def install
    args = std_meson_args + %w[
      -Dx11-backend=false
      -Dmacos-backend=true
      -Dgtk_doc=false
      -Dman-pages=true
      -Dintrospection=enabled
      -Dbuild-examples=false
      -Dbuild-tests=false
    ]

    args << "-Dprint-cups=disabled" if MacOS.version <= :mojave

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system bin/"gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["glib"].opt_bin}/gio-querymodules #{HOMEBREW_PREFIX}/lib/gtk-4.0/4.0.0/immodules.cache"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtk4").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/gtk4.pc").strip
  end
end
