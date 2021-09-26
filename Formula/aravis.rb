class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.18/aravis-0.8.18.tar.xz"
  sha256 "57730381924db0ae37315f9d3b477dcddcda2da95300acc81c3590a04e37dfaa"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "93a902897e4190256b5c408042c628cdc87d574b7a51bfcddc0bccfdb6b96872"
    sha256 big_sur:       "23b77eee19624a23678d18f99ed08a3e45d573ab6bcef6cd988e5e6120772e25"
    sha256 catalina:      "9dfb9f5e06dc5739c6d03ed0f22d998e5a44666f47183faada9c2a36cf107d24"
    sha256 mojave:        "bbcbd59ea3258b7da26ca122df6fb4b1d3e19c2cd2baa5a3962e0219d95be718"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gst-plugins-bad"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "intltool"
  depends_on "libnotify"
  depends_on "libusb"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.#{version.major_minor}.dylib")
    assert_match(/Description *Aravis Video Source/, output)
  end
end
