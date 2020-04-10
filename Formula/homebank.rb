class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.4.tar.gz"
  sha256 "3110b079ecae7efbf46c0ae980029e6355ee320440b71b4c6f0c7e66f4cd9aa7"

  bottle do
    sha256 "2b019f90f611cfa3765abfe40eba368deb2f3c0bea5793b3db5325f16c498b96" => :catalina
    sha256 "7a07804a2fe7503be3f56b328a0826c27206efa5b78857eb536036d4c15b96a3" => :mojave
    sha256 "158df2a8f301b494456dee58130618f9e6e9f3c8893c138d2a06b3a737494117" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ofx"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end
