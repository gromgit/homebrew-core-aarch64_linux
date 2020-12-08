class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.18.2.tar.xz"
  sha256 "6ea73d718bf1f9692218540ff88479c51d67c0b477fa56d6812fc7b739d30a56"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-devtools.git"

  bottle do
    sha256 "e156e8077e6ffc8efc6978d498376080d6e16fd39ae967f867c72caca49fc501" => :big_sur
    sha256 "0ad99a02a5f6b69fabaed767a22af18d97a84695362a9db8a2a267d9fd2afd86" => :catalina
    sha256 "c6d5be2d2ac2b289d55f48b319f2e84b3c79cb96f41571a629a0f28c31f69be1" => :mojave
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "json-glib"
  depends_on "python@3.9"

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dvalidate=enabled
      -Dtests=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    rewrite_shebang detected_python_shebang, bin/"gst-validate-launcher"
  end

  test do
    system "#{bin}/gst-validate-launcher", "--usage"
  end
end
