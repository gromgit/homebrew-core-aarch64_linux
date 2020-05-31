class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.25/libgphoto2-2.5.25.tar.bz2"
  sha256 "7c0e98f438c2b128186afe16ce7833a12fa36f87d01467e837b9d27e7a167f3a"

  bottle do
    sha256 "d9781e8d50a01f047bf2904574643ab7537da73ff96082d0e433c4c3cf201e34" => :catalina
    sha256 "31d09e0935ab63ca6ca833a04cdb6de3b595e32f0d6d0aa912c51b054c24a108" => :mojave
    sha256 "391e8211dac6d425b3f66cefd6c891b2603ecd6789ce930cc986cbdd09ac188d" => :high_sierra
  end

  head do
    url "https://github.com/gphoto/libgphoto2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libtool"
  depends_on "libusb-compat"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gphoto2/gphoto2-camera.h>
      int main(void) {
        Camera *camera;
        return gp_camera_new(&camera);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgphoto2", "-o", "test"
    system "./test"
  end
end
