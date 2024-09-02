class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/mptre/pick"
  url "https://github.com/mptre/pick/releases/download/v4.0.0/pick-4.0.0.tar.gz"
  sha256 "de768fd566fd4c7f7b630144c8120b779a61a8cd35898f0db42ba8af5131edca"
  license "MIT"
  head "https://github.com/mptre/pick.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pick"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "48df593a44555fef5b7a2eee7dc0053b08413bc3a7aa895e17cff06f57180c5a"
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
      begin
        assert_match(/foo\r\nbar\r\nbaz\r\n\^D.*foo\r\n\z/, r.read)
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
