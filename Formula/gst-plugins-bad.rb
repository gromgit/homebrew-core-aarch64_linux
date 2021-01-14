class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.18.3.tar.xz"
  sha256 "b7e34b6b86272588fbd8b314dadfa6ceff895198cfb59e2950378e9e31ff22e0"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/"
    regex(/href=.*?gst-plugins-bad[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "028e481c45c8157867afafc7e7bc80e5136cabc844d8fa3a10b029c7c7e8cdfc" => :big_sur
    sha256 "e0cb6b7e9a9c7e7fcc33e4bcbb2dde20fcde657460ae1ed4c1a78921361f262b" => :arm64_big_sur
    sha256 "d270c59485b1e4ff0548a65c34b17394297b8a9be83566543c03957de0740602" => :catalina
    sha256 "c020e55632de305e16a08fe795db0db2ff47e147314816f986e2dfe48ba08c50" => :mojave
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "faac"
  depends_on "faad2"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "libmms"
  depends_on "libnice"
  depends_on "libusrsctp"
  depends_on "musepack"
  depends_on "openssl@1.1"
  depends_on "opus"
  depends_on "orc"
  depends_on "rtmpdump"
  depends_on "srtp"

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dexamples=disabled
    ]

    # The apple media plug-in uses API that was added in Mojave
    args << "-Dapplemedia=disabled" if MacOS.version <= :high_sierra

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvbsuboverlay")
    assert_match version.to_s, output
  end
end
