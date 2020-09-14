class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.38/adwaita-icon-theme-3.38.0.tar.xz"
  sha256 "6683a1aaf2430ccd9ea638dd4bfe1002bc92b412050c3dba20e480f979faaf97"
  license any_of: ["LGPL-3.0-or-later", "CC-BY-SA-3.0"]

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "68833a3f5aff79bdf75c2e761a8451750b93e8a955e49356a78a2a3f0e1fbcd8" => :catalina
    sha256 "68833a3f5aff79bdf75c2e761a8451750b93e8a955e49356a78a2a3f0e1fbcd8" => :mojave
    sha256 "68833a3f5aff79bdf75c2e761a8451750b93e8a955e49356a78a2a3f0e1fbcd8" => :high_sierra
  end

  depends_on "gettext" => :build
  depends_on "gtk+3" => :build # for gtk3-update-icon-cache
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "librsvg"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "GTK_UPDATE_ICON_CACHE=#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache"
    system "make", "install"
  end

  test do
    # This checks that a -symbolic png file generated from svg exists
    # and that a file created late in the install process exists.
    # Someone who understands GTK+3 could probably write better tests that
    # check if GTK+3 can find the icons.
    png = "weather-storm-symbolic.symbolic.png"
    assert_predicate share/"icons/Adwaita/96x96/status/#{png}", :exist?
    assert_predicate share/"icons/Adwaita/index.theme", :exist?
  end
end
