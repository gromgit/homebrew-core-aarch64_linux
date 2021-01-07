class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.18.2.tar.xz"
  sha256 "36969ad44c5f0756a8a90215410710d6c39713d58f6cee13d663be9774557f49"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://gitlab.freedesktop.org/gstreamer/gst-libav.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-libav/"
    regex(/href=.*?gst-libav[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "2b6d7062a96bed51182f712ce2632602cdd46b92c11ee648795dbf8af44e55bc" => :big_sur
    sha256 "bde9b0dd591630feef32f7ff4ef9f6259419a194c28eb363e4ffb8eb675249ce" => :arm64_big_sur
    sha256 "d4c5d3dcb35e70402f8e1c03e4ef20ff748e60e7b80a47b75230f6869385c0f1" => :catalina
    sha256 "44225f1d4edde2abd5d09f398452275c033ac6a2b4a6c2a92f17ec5c20cf037f" => :mojave
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "ffmpeg"
  depends_on "gst-plugins-base"
  depends_on "xz" # For LZMA

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "libav"
  end
end
