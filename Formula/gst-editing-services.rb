class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.16.2.tar.xz"
  sha256 "0e06a6191a0c6c16e16272bf2573cecaeb245f10629486ad940a299bef700c16"

  bottle do
    sha256 "2989c392e6784984644d2c200c16ba5377487e5233ced15ce0abfe352c7a19b6" => :catalina
    sha256 "2ee5c075c178a4b3fbaf660e256a9c7972ad740b6ba6c6a3499a749c3828fc25" => :mojave
    sha256 "c3f48c4ab638e4787d97da06d10fc6102dfb6de9b8c59a6838a1845a73c463c6" => :high_sierra
    sha256 "97a43fc06ee67c0a9522695c1d761e6e9a324ce6409ccc25aaa447b90909f47e" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-gtk-doc",
                          "--disable-docbook"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ges-launch-1.0", "--ges-version"
  end
end
