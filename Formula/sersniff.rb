class Sersniff < Formula
  desc "Program to tunnel/sniff between 2 serial ports"
  homepage "https://www.earth.li/projectpurple/progs/sersniff.html"
  url "https://www.earth.li/projectpurple/files/sersniff-0.0.5.tar.gz"
  sha256 "8aa93f3b81030bcc6ff3935a48c1fd58baab8f964b1d5e24f0aaecbd78347209"
  license "GPL-2.0"
  head "https://the.earth.li/git/sersniff.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sersniff"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "05ab9c7b8460f166ea6605acaf67c54c0a4fb2d6898a8578307c4417a26ead03"
  end

  def install
    system "make"
    bin.install "sersniff"
    man8.install "sersniff.8"
  end

  test do
    assert_match(/sersniff v#{version}/,
                 shell_output("#{bin}/sersniff -h 2>&1", 1))
  end
end
