class Nbsdgames < Formula
  desc "Text-based modern games"
  homepage "https://github.com/abakh/nbsdgames"
  url "https://github.com/abakh/nbsdgames/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "b4ba777791274af7db13d2827b254cf998a757468e119c6ee106ccbeafcd04c1"
  license :public_domain
  head "https://github.com/abakh/nbsdgames.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4a0d3a3303316461210d74b93b5f25e6ecdbe332ed9262d2f6651510aea4d7bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "0992d4835169bbdb6e036557ba6dab0459e405a6af9bab245e52b016dbc1e6ec"
    sha256 cellar: :any_skip_relocation, catalina:      "1e5fdfafa10957f4740d1b8bfe8c28ffe1952f64883f923278f354fd1cc98817"
    sha256 cellar: :any_skip_relocation, mojave:        "1d8fc4cf13fca03c4e517a41e811be09906d3f799a0fc8473b9c8d922c9135a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b726aba152abea07b43fdb2473325d009ca67abaee063ccc1dfad495dc57c00"
  end

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
