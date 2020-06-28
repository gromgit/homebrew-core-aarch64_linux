class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.34/baobab-3.34.1.tar.xz"
  sha256 "7f981d4f135e4f80fba3f66e86b0eeedc94a2434649262ff01a5f0cb027b20c5"

  bottle do
    sha256 "353541c0846978cc3e7b44b9f2ad75b04e4c7515014903356ce3eb672931e27d" => :catalina
    sha256 "09eefe6e55e61258578eb35cfe7ada9174ff17cf7daeef8dee875c2d5ca2c333" => :mojave
    sha256 "a4f50d8cfa3cfb9f5ae6621c91767aefde34c12e1934f2f4ab5ba3587a30d281" => :high_sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baobab --version")
  end
end
