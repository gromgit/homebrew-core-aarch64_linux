class Libosinfo < Formula
  desc "Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.9.0.tar.xz"
  sha256 "b4f3418154ef3f43d9420827294916aea1827021afc06e1644fc56951830a359"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?libosinfo[._-]v?([\d.]+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "152cf602867b1aa39692a57f0fe05b56206c3754379baf175c781c9244213407"
    sha256 big_sur:       "485f4ed04f60420b754b32014321e797d05a52f56c066ef8e0d5bd084e03b101"
    sha256 catalina:      "6a779d888f548649d3482452583ced807c9aceca45bb0989122b22822ec82316"
    sha256 mojave:        "60e18106b7dca908a79e1edf59cd090ecb3a11d611d84330806aa0941fedb035"
    sha256 high_sierra:   "eabb00c969fe4686063a44b6d58170bc566972278d8b27468ac56341e7d083d3"
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
  depends_on "usb.ids"

  resource "pci.ids" do
    url "https://raw.githubusercontent.com/pciutils/pciids/7906a7b1f2d046072fe5fed27236381cff4c5624/pci.ids"
    sha256 "255229b8b37474c949736bc4a048a721e31180bb8dae9d8f210e64af51089fe8"
  end

  def install
    (share/"misc").install resource("pci.ids")

    mkdir "build" do
      flags = %W[
        -Denable-gtk-doc=false
        -Dwith-pci-ids-path=#{share/"misc/pci.ids"}
        -Dwith-usb-ids-path=#{Formula["usb.ids"].opt_share/"misc/usb.ids"}
        -Dsysconfdir=#{etc}
      ]
      system "meson", *std_meson_args, *flags, ".."
      system "ninja", "install", "-v"
    end
    (share/"osinfo/.keep").write ""
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <osinfo/osinfo.h>

      int main(int argc, char *argv[]) {
        GError *err = NULL;
        OsinfoPlatformList *list = osinfo_platformlist_new();
        OsinfoLoader *loader = osinfo_loader_new();
        osinfo_loader_process_system_path(loader, &err);
        if (err != NULL) {
          fprintf(stderr, "%s", err->message);
          return 1;
        }
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
    system bin/"osinfo-query", "device"
  end
end
