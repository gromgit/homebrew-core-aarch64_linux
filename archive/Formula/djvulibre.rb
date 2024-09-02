class Djvulibre < Formula
  desc "DjVu viewer"
  homepage "https://djvu.sourceforge.io/"
  url "https://downloads.sourceforge.net/djvu/djvulibre-3.5.28.tar.gz"
  sha256 "fcd009ea7654fde5a83600eb80757bd3a76998e47d13c66b54c8db849f8f2edc"

  livecheck do
    url :stable
    regex(%r{url=.*?/djvulibre[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/djvulibre"
    sha256 aarch64_linux: "4c2445360ab36e401d39904712acb0ea36e4b47c2c5388d701001a6f39e0a156"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jpeg"
  depends_on "libtiff"

  def install
    system "./autogen.sh"
    # Don't build X11 GUI apps, Spotlight Importer or QuickLook plugin
    system "./configure", "--prefix=#{prefix}", "--disable-desktopfiles"
    system "make"
    system "make", "install"
    (share/"doc/djvu").install Dir["doc/*"]
  end

  test do
    output = shell_output("#{bin}/djvused -e n #{share}/doc/djvu/lizard2002.djvu")
    assert_equal "2", output.strip
  end
end
