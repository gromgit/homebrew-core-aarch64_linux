class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.36/simple-scan-3.36.6.tar.xz"
  sha256 "da03a45967b6caac51d6c4aad2f4b05a6188e8bdaf4ce1bd318996282dfe3075"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "78d20e5cb4ae5f23c581600f2f5157adc6d23789dcd62569b3f109f23388b4ce" => :catalina
    sha256 "76c9db763fd53ab8c47a677f14fc7acd83411d542af61f043983453a467f0d65" => :mojave
    sha256 "3b7235684748e6aaa08d03ea4218b333476a115a1523efc46b18e9fa9f5ee90c" => :high_sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgusb"
  depends_on "sane-backends"
  depends_on "webp"

  def install
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/simple-scan", "-v"
  end
end
