class Yetris < Formula
  desc "Customizable Tetris for the terminal"
  homepage "https://github.com/alexdantas/yetris"
  url "https://github.com/alexdantas/yetris/archive/v2.3.0.tar.gz"
  sha256 "720c222325361e855e2dcfec34f8f0ae61dd418867a87f7af03c9a59d723b919"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/yetris"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6ca3f3af49e1a836c340e8aa11ee72aef523b2d0bfa0e92970684d22f3627c70"
  end

  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/yetris --version")
  end
end
