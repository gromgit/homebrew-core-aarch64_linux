class Tz < Formula
  desc "CLI time zone visualizer"
  homepage "https://github.com/oz/tz"
  url "https://github.com/oz/tz/archive/refs/tags/v0.4.tar.gz"
  sha256 "79764c29b66c2d5a158967e58ae0ca413f1af590b63920016ad7f0767f8c8494"
  license "GPL-3.0-or-later"
  head "https://github.com/oz/tz.git"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    # If https://github.com/oz/tz/issues/9 is fixed we can test this more
    # directly; right now it only runs in interactive mode.  Also bubbletea
    # apps don't respond well to PTY.spawn (or driving them under expect)
    # so not much gets printed.  Just make sure we get some ANSI out of it.
    require "pty"
    r, _, pid = PTY.spawn "#{bin}/tz"
    sleep 1
    Process.kill("TERM", pid)
    assert_match(/\e\[/, r.read)
  end
end
