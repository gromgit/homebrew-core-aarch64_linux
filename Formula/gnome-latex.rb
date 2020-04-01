class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/GNOME-LaTeX"
  url "https://download.gnome.org/sources/gnome-latex/3.36/gnome-latex-3.36.0.tar.xz"
  sha256 "1657238f4e2b419fe211e4b0b51a20889f44e6e3f498b87e25e032f8439ec9a0"

  bottle do
    sha256 "0174864eea6bbd293cfb28bf16c10ed3b3831ccb68f8e1e5258393c3b59a0fba" => :catalina
    sha256 "af13d2889f09fc84d8292077fb2110ab2de980714a3d5bf3486d012ea44a8776" => :mojave
    sha256 "13d8828c931ec9274afbde60c926acce7f32009c236b4d334eefe721e08e854b" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gnome-themes-standard"
  depends_on "gspell"
  depends_on "libgee"
  depends_on "tepl"

  def install
    system "./configure", "--disable-schemas-compile",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-dconf-migration",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas",
           "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t",
           "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t",
           "#{HOMEBREW_PREFIX}/share/icons/HighContrast"
  end

  test do
    system "#{bin}/gnome-latex", "--version"
  end
end
