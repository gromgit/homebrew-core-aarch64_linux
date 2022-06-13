class Zork < Formula
  desc "Dungeon modified from FORTRAN to C"
  homepage "https://github.com/devshane/zork"
  url "https://github.com/devshane/zork/archive/v1.0.3.tar.gz"
  sha256 "929871abae9be902d4fb592f2e76e52b58b386d208f127c826ae1d7b7bade9ef"
  head "https://github.com/devshane/zork.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/zork"
    sha256 aarch64_linux: "16b993188b83cf7296179d56fd9c2a711613f9e2a3745d44ac55e7ae4fe544ea"
  end

  uses_from_macos "ncurses"

  def install
    system "make", "DATADIR=#{share}", "BINDIR=#{bin}"
    system "make", "install", "DATADIR=#{share}", "BINDIR=#{bin}", "MANDIR=#{man}"
  end

  test do
    test_phrase = <<~EOS.chomp
      Welcome to Dungeon.\t\t\tThis version created 11-MAR-91.
      You are in an open field west of a big white house with a boarded
      front door.
      There is a small mailbox here.
      >Opening the mailbox reveals:
        A leaflet.
      >
    EOS
    assert_equal test_phrase, pipe_output("#{bin}/zork", "open mailbox", 0)
  end
end
