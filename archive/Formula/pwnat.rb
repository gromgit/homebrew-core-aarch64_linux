class Pwnat < Formula
  desc "Proxy server that works behind a NAT"
  homepage "https://samy.pl/pwnat/"
  url "https://github.com/samyk/pwnat/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "c784ac0ef2249ae5b314a95ff5049f16c253c1f9b3720f3f88c50fc811140b44"
  license "GPL-3.0-or-later"
  head "https://github.com/samyk/pwnat.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pwnat"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d1f80e3ec1daa061a4051fc71a09503681441f70642ee07ddd51a87d7fd20c0a"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=-lz"
    bin.install "pwnat"
    man1.install "manpage.txt" => "pwnat.1"
  end

  test do
    assert_match "pwnat <-s | -c> <args>", shell_output("#{bin}/pwnat -h", 1)
  end
end
