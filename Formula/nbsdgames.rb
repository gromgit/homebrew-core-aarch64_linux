class Nbsdgames < Formula
  desc "Text-based modern games"
  homepage "https://github.com/abakh/nbsdgames"
  url "https://github.com/abakh/nbsdgames/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "85d4de6530ed34a9ac24317a724247162d6839644b2106d494718f37e68e72da"
  license :public_domain
  head "https://github.com/abakh/nbsdgames.git"

  uses_from_macos "ncurses"

  def install
    mkdir bin
    system "make", "install",
           "GAMES_DIR=#{bin}",
           "SCORES_DIR=#{var}/games"

    mkdir man6
    system "make", "manpages", "MAN_DIR=#{man6}"
  end

  test do
    assert_equal "2 <= size <= 7", shell_output("#{bin}/sudoku 1", 1).chomp
  end
end
