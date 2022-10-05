class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.5.7.tar.gz"
  sha256 "ada0165f2883ca47af3cea8907c05e6080bc2d04274deebb58bd84b00c3b2838"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "2cf244f9bab4fa2d0d492819c54555c4cbe27040589f3ea63ed429e78789557c"
    sha256 arm64_big_sur:  "7e66fa1ed8e4f6dc62beb5cbfceb7594bb51ede3cceb3786379ba7e96b76306b"
    sha256 monterey:       "66d79402ec99b25f258c4fd69c9226cfc7e0f48f4a63400a09bf9c16d92fb3e9"
    sha256 big_sur:        "50c6ea69a69a7b3a9056415c441b32107050a98181493442c34cb68390a80315"
    sha256 catalina:       "4085957bfa7f3379a204061b8a07383849f5fd9c55e8af5aaefa778b9d614be5"
    sha256 x86_64_linux:   "ceb14ee33c2f22f9735dbe55cb47e854ee804df5b83db6d244d3eda1199e9ac5"
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
  depends_on "libsoup@2"

  def install
    if OS.linux?
      # Needed to find intltool (xml::parser)
      ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ofx"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end
