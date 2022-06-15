class Moe < Formula
  desc "Console text editor for ISO-8859 and ASCII"
  homepage "https://www.gnu.org/software/moe/moe.html"
  url "https://ftp.gnu.org/gnu/moe/moe-1.12.tar.lz"
  mirror "https://ftpmirror.gnu.org/moe/moe-1.12.tar.lz"
  sha256 "8a885f2be426f8e04ad39c96012bd860954085a23744f2451663168826d7a1e8"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/moe"
    sha256 aarch64_linux: "48894135b0006762705ddf8ab0200597af6c243f6fa5797b11c082e366cffd78"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/moe", "--version"
  end
end
