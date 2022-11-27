class TtyClock < Formula
  desc "Digital clock in ncurses"
  homepage "https://github.com/xorg62/tty-clock"
  url "https://github.com/xorg62/tty-clock/archive/v2.3.tar.gz"
  sha256 "343e119858db7d5622a545e15a3bbfde65c107440700b62f9df0926db8f57984"
  license "BSD-3-Clause"
  head "https://github.com/xorg62/tty-clock.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/tty-clock"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5ccd4413342fb4adfab89b1d9854296a2b11a6a957a1c6c3bb9bc272f3c61998"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "ncurses"

  def install
    ENV.append "LDFLAGS", "-lncurses"
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/tty-clock", "-i"
  end
end
