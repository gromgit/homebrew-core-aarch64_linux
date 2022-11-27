class Pacman4console < Formula
  desc "Pacman for console"
  homepage "https://sites.google.com/site/doctormike/pacman.html"
  url "https://ftp.debian.org/debian/pool/main/p/pacman4console/pacman4console_1.3.orig.tar.gz"
  sha256 "9a5c4a96395ce4a3b26a9896343a2cdf488182da1b96374a13bf5d811679eb90"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pacman4console"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e0cd3fe64d58f6e96cd349815b757e4f0f61cf3416187c0bcf30dbdeb59610f4"
  end

  # The Google Sites website is no longer available.
  deprecate! date: "2021-10-23", because: :unmaintained

  uses_from_macos "ncurses"

  def install
    system "make", "prefix=#{prefix}", "datarootdir=#{pkgshare}"
    bin.install ["pacman", "pacmanedit"]
    (pkgshare+"pacman").install "Levels"
  end
end
