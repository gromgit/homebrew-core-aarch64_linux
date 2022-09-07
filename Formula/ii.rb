class Ii < Formula
  desc "Minimalist IRC client"
  homepage "https://tools.suckless.org/ii/"
  url "https://dl.suckless.org/tools/ii-1.8.tar.gz"
  sha256 "b9d9e1eae25e63071960e921af8b217ab1abe64210bd290994aca178a8dc68d2"
  license "MIT"
  head "https://git.suckless.org/ii", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?ii[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ii"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "15ad01618e92588c3d3e94b968c6463c7174ededc61a66656eff25d95058fea8"
  end

  def install
    # Fixed upstream, drop for next version
    inreplace "Makefile", "SRC = ii.c strlcpy.c", "SRC = ii.c" if OS.mac?

    system "make", "install", "PREFIX=#{prefix}"
  end
end
