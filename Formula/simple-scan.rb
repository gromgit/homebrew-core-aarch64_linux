class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.34/simple-scan-3.34.4.tar.xz"
  sha256 "7f341beebd49ea0a7477dc5c28459aa96bac04b348d56e69d3d250ffc5317e77"

  bottle do
    sha256 "c8335e327170c50817798510f540f76ef5a062dc2c7705a5b99f69b909308319" => :catalina
    sha256 "7c95278f53cbb13c8128bb812b6bc2bd26eb1042b711034ff600055aa6b90edd" => :mojave
    sha256 "c9b134c5ae257e94d08a239111b8cb6ad18707e716aad0dd88fda2c800236d8a" => :high_sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgusb"
  depends_on "sane-backends"
  depends_on "webp"

  def install
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
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
