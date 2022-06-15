class Smake < Formula
  desc "Portable make program with automake features"
  homepage "https://s-make.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/s-make/smake-1.2.5.tar.bz2"
  sha256 "27566aa731a400c791cd95361cc755288b44ff659fa879933d4ea35d052259d4"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/smake"
    sha256 aarch64_linux: "6b9f73efbcf9f3a28337aa200d756c45997aaeeaae151ffc48e87912111dfebd"
  end

  def install
    # ARM fails to build with Os
    ENV.O1 if Hardware::CPU.arm?

    system "make", "GMAKE_NOWARN=true", "INS_BASE=#{libexec}", "INS_RBASE=#{libexec}", "install"
    bin.install_symlink libexec/"bin/smake"
    man1.install_symlink Dir["#{libexec}/share/man/man1/*.1"]
    man5.install_symlink Dir["#{libexec}/share/man/man5/*.5"]
  end

  test do
    system "#{bin}/smake", "-version"
  end
end
