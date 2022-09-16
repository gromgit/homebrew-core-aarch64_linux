class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 arm64_monterey: "f7f6d9a5b94a4a65519cf8b8da797250f4884b0a62d8dfd7b63c85ad2992ca8c"
    sha256 arm64_big_sur:  "fa7dc7e193cde7d21642cfe2d89748a4638ee1eb5ada154d46b6aabcaf8ab729"
    sha256 monterey:       "b77a98824f1a20240a523635994ff656b74557fb0466e971f93610ba76b827d2"
    sha256 big_sur:        "4636c8dbdb1f175e52f4a170f15a11a3f5b5cb7d5e23cf4fa42f11b6da0640b2"
    sha256 catalina:       "fc5f5522045309048d206d1dc6495fa04b5d1486e5574ba97a026d941930ff5e"
    sha256 x86_64_linux:   "e11bcd4f8ff62ed570fafa8fa225176f0382aec3fb94197e51bd76f29ba6e162"
  end

  depends_on "boost"
  uses_from_macos "ncurses"

  # Fix compilation with Boost >= 1.65, remove for next release
  patch do
    url "https://github.com/fph/bastet/commit/0e03f8d4.patch?full_index=1"
    sha256 "9b937d070a4faf150f60f82ace790c7a1119cff0685b52edf579740d2c415d7b"
  end

  def install
    inreplace %w[Config.cpp bastet.6], "/var", var

    system "make", "all"

    # this must exist for games to be saved globally
    (var/"games").mkpath
    touch "#{var}/games/bastet.scores2"

    bin.install "bastet"
    man6.install "bastet.6"
  end

  test do
    pid = fork do
      exec bin/"bastet"
    end
    sleep 3

    assert_predicate bin/"bastet", :exist?
    assert_predicate bin/"bastet", :executable?
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
