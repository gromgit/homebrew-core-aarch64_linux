class Figlet < Formula
  desc "Banner-like program prints strings as ASCII art"
  homepage "http://www.figlet.org/"
  url "http://ftp.figlet.org/pub/figlet/program/unix/figlet-2.2.5.tar.gz"
  mirror "https://fossies.org/linux/misc/figlet-2.2.5.tar.gz"
  sha256 "bf88c40fd0f077dab2712f54f8d39ac952e4e9f2e1882f1195be9e5e4257417d"
  license "BSD-3-Clause"

  livecheck do
    url "http://ftp.figlet.org/pub/figlet/program/unix/"
    regex(/href=.*?figlet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/figlet"
    sha256 aarch64_linux: "477bb210ceb5d8262ae5ad42b5ba00fb64d0acbcf4ae009b40c67d776d4e5959"
  end

  resource "contrib" do
    url "http://ftp.figlet.org/pub/figlet/fonts/contributed.tar.gz"
    mirror "https://www.minix3.org/distfiles-backup/figlet-fonts-20021023/contributed.tar.gz"
    mirror "https://downloads.sourceforge.net/project/fullauto/FIGlet%20Fonts/contributed.tar.gz"
    sha256 "2c569e052e638b28e4205023ae717f7b07e05695b728e4c80f4ce700354b18c8"
  end

  resource "intl" do
    url "http://ftp.figlet.org/pub/figlet/fonts/international.tar.gz"
    mirror "https://www.minix3.org/distfiles-backup/figlet-fonts-20021023/international.tar.gz"
    mirror "https://downloads.sourceforge.net/project/fullauto/FIGlet%20Fonts/international.tar.gz"
    sha256 "e6493f51c96f8671c29ab879a533c50b31ade681acfb59e50bae6b765e70c65a"
  end

  def install
    (pkgshare/"fonts").install resource("contrib"), resource("intl")

    chmod 0666, %w[Makefile showfigfonts]
    man6.mkpath
    bin.mkpath

    system "make", "prefix=#{prefix}",
                   "DEFAULTFONTDIR=#{pkgshare}/fonts",
                   "MANDIR=#{man}",
                   "install"
  end

  test do
    system "#{bin}/figlet", "-f", "larry3d", "hello, figlet"
  end
end
