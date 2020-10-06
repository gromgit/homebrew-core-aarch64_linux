class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.10.1/vips-8.10.1.tar.gz"
  sha256 "e089bb4f73e1dce866ae53e25604ea4f94535488a45bb4f633032e1d2f4e2dda"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 "0ff53f9fae72ead39ff7177c9b1bf8722bfd87a358ec00a939ab7d7c5404376b" => :catalina
    sha256 "b9396b92a8b4603194246eedd931072b8a5010d9091abe919a6f2ab8642d93fb" => :mojave
    sha256 "a86af59ecced5ca18765ea8acf0c546c2b6162925b6d038b742400036269eca9" => :high_sierra
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
