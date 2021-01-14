class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-1.18.3.tar.xz"
  sha256 "8ae139b13b1646a20ba63b0b90877d35813e24cd87642d325e751fc7cb175e20"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-editing-services/"
    regex(/href=.*?gst(?:reamer)?-editing-services[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "dd9f24b2a74ed89bab046a3e93af2386c5158635658f9a7c789dd4a1c3f9fce0" => :big_sur
    sha256 "8a843f15f8b7a9f7918948293bc7f47364e35f579089d1fbb7c94ed06b791578" => :arm64_big_sur
    sha256 "a164c36336638e554d27741b1dfb0488f83cc2c11ab02ee658df2f10350b96ac" => :catalina
    sha256 "8572a52cccb815e67f0ddcae4be0a2bcbfd8f10f1dc7636f71b7b7bc12898317" => :mojave
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dtests=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/ges-launch-1.0", "--ges-version"
  end
end
