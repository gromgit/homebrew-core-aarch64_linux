class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  url "https://download.gnome.org/sources/gnome-recipes/2.0/gnome-recipes-2.0.2.tar.xz"
  sha256 "1be9d2fcb7404a97aa029d2409880643f15071c37039247a6a4320e7478cd5fb"
  revision 12

  bottle do
    sha256 "ccc25a49187490088f2a651bab5351202139dcc2827046d19553a135ac14d4af" => :catalina
    sha256 "65e87e975f213423cb52dacf5cef57dddd3d44e3fb9291192b302ddf0274e84d" => :mojave
    sha256 "75937f34860d7d21b01c8182072b5288fbde27462426928d934d932d9ae91079" => :high_sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gnome-autoar"
  depends_on "gnu-tar"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "json-glib" # for goa
  depends_on "libcanberra"
  depends_on "librest" # for goa
  depends_on "libsoup"
  depends_on "libxml2"

  resource "goa" do
    url "https://download.gnome.org/sources/gnome-online-accounts/3.30/gnome-online-accounts-3.30.2.tar.xz"
    sha256 "05c7e588c884a4145db376880303588f74b76d1fa11afbeccb74c6eff36b2fdc"
  end

  def install
    resource("goa").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--disable-backend"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    # BSD tar does not support the required options
    inreplace "src/gr-recipe-store.c", "argv[0] = \"tar\";", "argv[0] = \"gtar\";"
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = ""
    ENV.delete "PYTHONPATH"
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
    system "#{bin}/gnome-recipes", "--help"
  end
end
