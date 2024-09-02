class Mpgtx < Formula
  desc "Toolbox to manipulate MPEG files"
  homepage "https://mpgtx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mpgtx/mpgtx/1.3.1/mpgtx-1.3.1.tar.gz"
  sha256 "8815e73e98b862f12ba1ef5eaaf49407cf211c1f668c5ee325bf04af27f8e377"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/mpgtx[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)(?:-src)?\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mpgtx"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "431e2a70668a901e2ee6fc38173be250ce801fcc743aee52664e5dd238db7803"
  end

  def install
    system "./configure", "--parachute",
                          "--prefix=#{prefix}",
                          "--manprefix=#{man}"
    # Unset LFLAGS, "-s" causes the linker to crash
    system "make", "LFLAGS="
    # Override BSD incompatible cp flags set in makefile
    system "make", "install", "cpflags=RP"
  end

  test do
    system "#{bin}/mpgtx", "--version"
  end
end
