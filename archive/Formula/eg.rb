class Eg < Formula
  desc "Expert Guide. Norton Guide Reader For GNU/Linux"
  homepage "https://github.com/davep/eg"
  url "https://github.com/davep/eg/archive/v1.02.tar.gz"
  sha256 "6b73fff51b5cf82e94cdd60f295a8f80e7bbb059891d4c75d5b1a6f0c5cc7003"
  license "GPL-2.0"
  head "https://github.com/davep/eg.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/eg"
    sha256 aarch64_linux: "a52ab19fec51e7f15f196532930c32d1ad77d2a754c35fbe415d7ed6e2f5e548"
  end

  depends_on "s-lang"

  def install
    inreplace "eglib.c", "/usr/share/", "#{etc}/"
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}", "NGDIR=#{etc}/norton-guides"
  end

  test do
    # It will return a non-zero exit code when called with any option
    # except a filename, but will return success if the file doesn't
    # exist, without popping into the UI - we're exploiting this here.
    ENV["TERM"] = "xterm"
    system bin/"eg", "not_here.ng"
  end
end
