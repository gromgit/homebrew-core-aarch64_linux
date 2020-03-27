class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.36/simple-scan-3.36.1.tar.xz"
  sha256 "7427f0902253e01383941243f56ef987609943c537f92dd1043a53eb5eaaf92e"

  bottle do
    sha256 "18aac59ffddf44639d9be271ddd6fd45a2dbd43b010e42a9b505a5cd228cd370" => :catalina
    sha256 "318a673d8a28fda2cdfc376fed25efc1a4689d9ba0f61abc7a5d0309c2cfd379" => :mojave
    sha256 "86a1651a7f08f13e1177ef00a6f0296545dcf71d014c8e85a6a450d808c1fab0" => :high_sierra
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
