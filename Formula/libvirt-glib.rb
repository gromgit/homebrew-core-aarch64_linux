class LibvirtGlib < Formula
  desc "Libvirt API for glib-based programs"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/glib/libvirt-glib-4.0.0.tar.xz"
  sha256 "8423f7069daa476307321d1c11e2ecc285340cd32ca9fc05207762843edeacbd"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://libvirt.org/sources/glib/"
    regex(/href=.*?libvirt-glib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 big_sur:     "6fe016260618ce29746ac834739030d6b2e6c7a8325974cf56521266a87c8599"
    sha256 catalina:    "167725ebc46919472e205ae7f11953ac1dd1a6b7d4431fa8a54f720dd8d32717"
    sha256 mojave:      "836139b6c4349752f9e5e6ce0863f3129602c54ee040caf0e8bb31ea97a6bf3f"
    sha256 high_sierra: "fd81e19fae3e2855e61e9519ec829859fd3a9956927c47396af123611c6a23cd"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"
  depends_on "glib"
  depends_on "libvirt"

  def install
    system "meson", "setup", "builddir", *std_meson_args, "-Dintrospection=enabled"
    cd "builddir" do
      system "meson", "compile"
      system "meson", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libvirt-gconfig/libvirt-gconfig.h>
      #include <libvirt-glib/libvirt-glib.h>
      #include <libvirt-gobject/libvirt-gobject.h>
      int main() {
        gvir_config_object_get_type();
        gvir_event_register();
        gvir_interface_get_type();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-I#{MacOS.sdk_path}/usr/include/libxml2",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{include}/libvirt-gconfig-1.0",
                   "-I#{include}/libvirt-glib-1.0",
                   "-I#{include}/libvirt-gobject-1.0",
                   "-L#{lib}",
                   "-lvirt-gconfig-1.0",
                   "-lvirt-glib-1.0",
                   "-lvirt-gobject-1.0",
                   "-o", "test"
    system "./test"
  end
end
