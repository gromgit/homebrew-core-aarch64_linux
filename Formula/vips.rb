class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.10.1/vips-8.10.1.tar.gz"
  sha256 "e089bb4f73e1dce866ae53e25604ea4f94535488a45bb4f633032e1d2f4e2dda"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 "d2a0d29e9b37b9f396d9f21d5483ac433d83de92335a87651e20dc0368fb26f4" => :catalina
    sha256 "0515b6dc422a35e1cea9e610e0c8360bb566cf2e4ba4add6f3824c613a5721f9" => :mojave
    sha256 "02d8833b1754a8da55e2f6c0c2154439f51b9b02785a33b8e20fdff54c9f9d6b" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "imagemagick"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libheif"
  depends_on "libimagequant"
  depends_on "libmatio"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libspng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "mozjpeg"
  depends_on "openexr"
  depends_on "openslide"
  depends_on "orc"
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gobject-introspection"
  end

  # Reported upstream at https://github.com/libvips/libvips/issues/1836
  # This patch is a reworked version of https://github.com/libvips/libvips/commit/e3181e05799fa1e51e1a4f8fc6884e3f9c3de765
  # To be removed when the next update is released
  patch :DATA

  def install
    # mozjpeg needs to appear before libjpeg, otherwise it's not used
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["mozjpeg"].opt_lib/"pkgconfig"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-magick
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    cmd = "#{bin}/vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp

    # --trellis-quant requires mozjpeg, vips warns if it's not present
    cmd = "#{bin}/vips jpegsave #{test_fixtures("test.png")} #{testpath}/test.jpg --trellis-quant 2>&1"
    assert_equal "", shell_output(cmd)

    # [palette] requires libimagequant, vips warns if it's not present
    cmd = "#{bin}/vips copy #{test_fixtures("test.png")} #{testpath}/test.png[palette] 2>&1"
    assert_equal "", shell_output(cmd)
  end
end

__END__
diff --git a/libvips/iofuncs/error.c b/libvips/iofuncs/error.c
index 165623843..746742cb3 100644
--- a/libvips/iofuncs/error.c
+++ b/libvips/iofuncs/error.c
@@ -71,7 +71,7 @@
 #endif /*OS_WIN32*/

 /**
- * SECTION: error
+ * SECTION: errors
  * @short_description: error messages and error handling
  * @stability: Stable
  * @include: vips/vips.h
diff --git a/libvips/iofuncs/rect.c b/libvips/iofuncs/rect.c
index 79ae69f76..9038efb9b 100644
--- a/libvips/iofuncs/rect.c
+++ b/libvips/iofuncs/rect.c
@@ -45,7 +45,7 @@
 #include <vips/vips.h>

 /**
- * SECTION: rect
+ * SECTION: rectangle
  * @short_description: the VIPS rectangle class
  * @stability: Stable
  * @see_also: <link linkend="VipsRegion">region</link>
diff --git a/libvips/resample/interpolate.c b/libvips/resample/interpolate.c
index 5ec50b742..d295ad9fa 100644
--- a/libvips/resample/interpolate.c
+++ b/libvips/resample/interpolate.c
@@ -63,7 +63,7 @@
 #include <vips/internal.h>

 /**
- * SECTION: interpolate
+ * SECTION: interpolator
  * @short_description: various interpolators: nearest, bilinear, and
  * some non-linear
  * @stability: Stable
