class Pngcheck < Formula
  desc "Print info and check PNG, JNG, and MNG files"
  homepage "http://www.libpng.org/pub/png/apps/pngcheck.html"
  url "https://downloads.sourceforge.net/project/png-mng/pngcheck/2.3.0/pngcheck-2.3.0.tar.gz"
  sha256 "77f0a039ac64df55fbd06af6f872fdbad4f639d009bbb5cd5cbe4db25690f35f"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/pngcheck[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0fef6b0676fa1f23b9fcd00e404a7d8b737d5deb7a940e8ca19df104dd767993" => :big_sur
    sha256 "744c6241d76de0249e24a3c754dcc5df2d39eb067d552ec86300ca9d607f439e" => :arm64_big_sur
    sha256 "7fb0d821218aba52e2c261c4cdcc50438d71cbf232baba97ef13e861c3386a11" => :catalina
    sha256 "22033aa6f7b96ecb9d7eb038b7103e5faa782f4d36c142c3220f1e1ff1fc9e9e" => :mojave
    sha256 "f4cdf56cdf51ab156bcc1009cce5cdd46d86de12811549136d50a1a18295b7c7" => :high_sierra
    sha256 "c98b0fd09e8b615f98d4ee9762485a8e9026c9cdb3dc576ef81ee0bbff6058d7" => :sierra
    sha256 "98e0a49125511f279c09c99fdb33ea5e2d44f489be4a8a6d70ce9faba48e8b92" => :el_capitan
    sha256 "2f8901f0259f2ec24478268e5fa4cd8fe904a160592f118efdddf4ba20221dd6" => :yosemite
    sha256 "af2af2a3771b7730c0da6fe3c74f6044b3664498c0b9f5070be3cf4d7ec1274e" => :mavericks
  end

  def install
    system "make", "-f", "Makefile.unx", "ZINC=", "ZLIB=-lz"
    bin.install %w[pngcheck pngsplit png-fix-IDAT-windowsize]
  end

  test do
    system bin/"pngcheck", test_fixtures("test.png")
  end
end
