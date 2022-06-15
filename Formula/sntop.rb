class Sntop < Formula
  desc "Curses-based utility that polls hosts to determine connectivity"
  homepage "https://sntop.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sntop/sntop/1.4.3/sntop-1.4.3.tar.gz"
  sha256 "943a5af1905c3ae7ead064e531cde6e9b3dc82598bbda26ed4a43788d81d6d89"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/sntop[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sntop"
    sha256 aarch64_linux: "1a328eab3a6c7d1fd9e9aa165497ef1abfe4e1432cd3fc4149f77a26d9420993"
  end

  depends_on "fping"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}"
    etc.mkpath
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      sntop uses fping by default and fping can only be run by root by default.
      You can run `sudo sntop` (or `sntop -p` which uses standard ping).
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    system "#{bin}/sntop", "--version"
  end
end
