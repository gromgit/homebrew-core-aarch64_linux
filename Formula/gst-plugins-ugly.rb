class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.18.3.tar.xz"
  sha256 "70f7429b25dd2f714eb18e80af61b1363b1f63019e16cd28e086e3a619eaa992"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/"
    regex(/href=.*?gst-plugins-ugly[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "cb86e77291ae8fddf9970104dd35692dd203700bb7478435eac7b7b69a1d9142" => :big_sur
    sha256 "88a88429d31270011aaf94fd43a8b21cdd4d9778df5ee87fd9b9ebdc838deef5" => :arm64_big_sur
    sha256 "95a7a76aecfe472051a07be32cb7b76f8d340ae12f3d8f56fa1546d81bab2348" => :catalina
    sha256 "a00090d74613bbe4bb3f22c9f2941364f97530ed0160c4888efc868af458969c" => :mojave
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "libmms"
  depends_on "libshout"
  depends_on "libvorbis"
  depends_on "pango"
  depends_on "theora"
  depends_on "x264"

  def install
    args = std_meson_args + %w[
      -Damrnb=disabled
      -Damwrbdec=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvdsub")
    assert_match version.to_s, output
    output = shell_output("#{gst} --plugin x264")
    assert_match version.to_s, output
  end
end
