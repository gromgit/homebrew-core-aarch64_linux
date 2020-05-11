class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.34/baobab-3.34.0.tar.xz"
  sha256 "46ebd9466da6a68c340653e9095f1e905b6fac79305879a9e644634f7da98607"
  revision 3

  bottle do
    sha256 "eeef57376a72b9637985b679e96cb3306edc024cc928344a3cefa6db7a45a7f8" => :catalina
    sha256 "b2bb3cefd3f5f6a69a5ad9daa0fbdac74ae101991aa76f6e2ecd52fc05be31ba" => :mojave
    sha256 "2bf9843dac3e84667dfe18c02c7537d647c99df84139704b23c55297e6373b95" => :high_sierra
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
