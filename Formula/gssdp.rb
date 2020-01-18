class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.2/gssdp-1.2.2.tar.xz"
  sha256 "cabb9e3b456b8354a55e23eb0207545d974643cda6d623523470ebbc4188b0a4"

  bottle do
    cellar :any
    sha256 "d0f477645aba1dae4ae4d0ebaee92dc61e7a4e10169a45d743b9337d2cd17534" => :catalina
    sha256 "2290af08181d27e7aa38ee9a005872b0c4c00b36b6d07bc35eb42ca475dfe73e" => :mojave
    sha256 "02e1fa177854c341451732648d6fe1d3872521efdcbaab7d6fc9427ae9b4fa6d" => :high_sierra
    sha256 "1c06bb7d867ca5f542e83340649e757ee07faf45540fdb37eb7685e600ef83ca" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dsniffer=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libgssdp/gssdp.h>

      int main(int argc, char *argv[]) {
        GType type = gssdp_client_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gssdp-1.2
      -D_REENTRANT
      -L#{lib}
      -lgssdp-1.2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
