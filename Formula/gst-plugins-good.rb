class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.18.2.tar.xz"
  sha256 "f71752dde434d9ec55fa5e8d2e2a3be3fc6eb5b34f397b065f84aead25b449a4"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-good.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/"
    regex(/href=.*?gst-plugins-good[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "b07e96e50c295fb252f3f18c0e46ac3bec92637d59e6d11482f2f26d9b98f177" => :big_sur
    sha256 "759a05231b24aae3a5ca8d65349ed3e3e31e940e96a983274684864ca8dbd6ee" => :catalina
    sha256 "129bc9722268b3e918514bc86e68e0905aa94bf512e75220b73a0f1ccf8c9390" => :mojave
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gtk+3"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libshout"
  depends_on "libsoup"
  depends_on "libvpx"
  depends_on "orc"
  depends_on "speex"
  depends_on "taglib"

  def install
    args = std_meson_args + %w[
      -Dgoom=disabled
      -Dximagesrc=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin cairo")
    assert_match version.to_s, output
  end
end
