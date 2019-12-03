class Libosinfo < Formula
  desc "The Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.7.1.tar.xz"
  sha256 "bb26106ad4a9f8523f81b332d2aedb717cdcb0500b3f68ba7c6ff945c4d627e9"

  bottle do
    sha256 "8242828a781ce96d398c46860ae0202afab5fe579b5e91aaa256e969fd85d0a6" => :catalina
    sha256 "c67caf435fca9b083f3928bd6983dcaf4347f33b16693e5f28debe5b216b012d" => :mojave
    sha256 "bed6f6794bcf73559378663f1856436508ab77572a9d6a79fce658ac6f320787" => :high_sierra
    sha256 "a9d1632746e463740d21c64cacfd00f9625664c14369c6089edf6aa3f29170b0" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "libxml2"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Denable-gtk-doc=false", ".."
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <osinfo/osinfo.h>

      int main(int argc, char *argv[]) {
        OsinfoPlatformList *list = osinfo_platformlist_new();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libosinfo-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -losinfo-1.0
      -lglib-2.0
      -lgobject-2.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
