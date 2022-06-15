class Sl < Formula
  desc "Prints a steam locomotive if you type sl instead of ls"
  homepage "https://github.com/mtoyoda/sl"
  url "https://github.com/mtoyoda/sl/archive/5.02.tar.gz"
  sha256 "1e5996757f879c81f202a18ad8e982195cf51c41727d3fea4af01fdcbbb5563a"
  license "MIT"
  head "https://github.com/mtoyoda/sl.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2387d6781b1692c339c76f9ca378c049d772eafb98aa479cb541a70497e6ce2f"
  end

  uses_from_macos "ncurses"

  def install
    system "make", "-e"
    bin.install "sl"
    man1.install "sl.1"
  end

  test do
    system "#{bin}/sl", "-c"
  end
end
