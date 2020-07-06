class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/mptre/pick"
  url "https://github.com/mptre/pick/releases/download/v4.0.0/pick-4.0.0.tar.gz"
  sha256 "de768fd566fd4c7f7b630144c8120b779a61a8cd35898f0db42ba8af5131edca"
  head "https://github.com/mptre/pick.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f5c3b2a34966596f3e5ddf33de5524f656aa558a00fcd6ef47c262115a872d6" => :catalina
    sha256 "4f376e252f19746091a38cc04c25ba95b69b91855e9655e91ddff1e79cc3b6f4" => :mojave
    sha256 "596b06179a358b1be315dedaef900d28c059ef710c428ecbbbb5072c2294380e" => :high_sierra
    sha256 "e91e7c5882344a8d2722c50bad65959aacfdef739206aec833722b6f00a2e8a2" => :sierra
  end

  uses_from_macos "ncurses"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man
    system "./configure"
    system "make", "install"
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"
    PTY.spawn(bin/"pick") do |r, w, _pid|
      w.write "foo\nbar\nbaz\n\x04"
      sleep 1
      w.write "\n"
      assert_match /foo\r\nbar\r\nbaz\r\n\^D.*foo\r\n\z/, r.read
    end
  end
end
