class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.12.0/freetype-2.12.0.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.12.0.tar.xz"
  sha256 "ef5c336aacc1a079ff9262d6308d6c2a066dd4d2a905301c4adda9b354399033"
  license "FTL"

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/freetype"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f1bb0a5a5ad96684d7fb7e8c608f655c132c1732ee0ae2c665b95406f11ce315"
  end

  depends_on "libpng"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-freetype-config",
                          "--without-harfbuzz"
    system "make"
    system "make", "install"

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end
