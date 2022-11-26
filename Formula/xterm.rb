class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-377.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_377.orig.tar.gz"
  sha256 "db108fe7a45d8ed97e604721b58443b473649e61e263631bf8759f8618a990b2"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "98b6cad6f1f9929c9d87b03bb29a1e65d557fb5dab373bd376c1d5c71144c851"
    sha256 arm64_monterey: "da19e9dd0f7e39b9041c6872cd4c8ba51920d767adc3eda32cae542eb4156743"
    sha256 arm64_big_sur:  "50578593cee87d06aafe1f336b1868db5d5ddc7c41035017c94e1d562d60e5d1"
    sha256 ventura:        "a7f32500e8ffc7ae7e623fe0dc2faa90e85cd920c5016088b079fd6138d43896"
    sha256 monterey:       "5a91032c9351651c629bf9f98bc5c5f226d40e401aaef15696c7d1e92fd2b3a0"
    sha256 big_sur:        "00969e337947753a17e1a906ca63de416516dae31ca940f58a685e270d2c87a8"
    sha256 catalina:       "e5b81394d3077132594a7309ac6845bd4e36eb52eba662db3fe82b9528233e5c"
    sha256 x86_64_linux:   "e67884b8fe83660f478c4c00fa8c751f5ff22341dd4c46970710635bf64106fb"
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libice"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxinerama"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    %w[koi8rxterm resize uxterm xterm].each do |exe|
      assert_predicate bin/exe, :exist?
      assert_predicate bin/exe, :executable?
    end
  end
end
