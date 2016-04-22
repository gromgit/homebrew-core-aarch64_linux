class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.8.1.tar.xz"
  sha256 "76a3bfb72f9cb81d2b2cf8d07e420478e5b3592ea4b8056bb8c8127f73810a98"

  bottle do
    sha256 "c10f8eecb52a3d1139c0e414c79a07b481c15fcd51a9674cba273a57e6605c62" => :el_capitan
    sha256 "adca010f73dd2df8fed604f5674e54caf6bb61904adb147f64f62fb974262ac0" => :yosemite
    sha256 "e708aa675d5744fc36608249728290d6d97803cd071bf2ac91d245a9d8e8c996" => :mavericks
  end

  depends_on "gst-plugins-base"
  depends_on "pygobject3"

  link_overwrite "lib/python2.7/site-packages/gi/overrides"

  def install
    # pygi-overrides-dir switch ensures files don't break out of sandbox.
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-pygi-overrides-dir=#{lib}/python2.7/site-packages/gi/overrides"
    system "make", "install"
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "python"
  end
end
