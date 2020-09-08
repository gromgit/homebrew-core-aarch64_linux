class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.18.0.tar.xz"
  sha256 "76bfe8b85a9c4a6ddfb81874f2635fd0da38c3f39d9d2a0b175213218516dd45"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-python/"
    regex(/href=.*?gst-python[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "c81ba537e1ffcf118f451c9bfd14316130b6fef8c4783200cab52a6b5eb494f9" => :catalina
    sha256 "baccf8cd73d36aba4ce9418639c70c15c48b1675a3bf4b8629cc6814f4014678" => :mojave
    sha256 "4f97f255287bcefc62d520f4c29111c3ec1012a582cc5251c00779c29b8a4a02" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gst-plugins-base"
  depends_on "pygobject3"
  depends_on "python@3.8"

  # See https://gitlab.freedesktop.org/gstreamer/gst-python/-/merge_requests/41
  patch do
    url "https://gitlab.freedesktop.org/gstreamer/gst-python/-/commit/3e752ede7ed6261681ef3831bc3dbb594f189e76.patch"
    sha256 "734291a1468dff21c61598a36ffa84776d33c113313f5a8c420829ea67f55e78"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system Formula["python@3.8"].opt_bin/"python3", "-c", <<~EOS
      import gi
      gi.require_version('Gst', '1.0')
      from gi.repository import Gst
      print (Gst.Fraction(num=3, denom=5))
    EOS
  end
end
