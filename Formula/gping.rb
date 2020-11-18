class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/v0.1.7.tar.gz"
  sha256 "5c2ff5e1d72fe1cc55b69eab073bb6ddec0fca1303313865e9c1d43bc52e85a3"
  license "MIT"
  head "https://github.com/orf/gping.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff8625f4110f7738f3c6e1b897b837e9deb3ff306b42158b11bc764ac71ddbed" => :big_sur
    sha256 "42501a0f26107b39eeea338bb1a44e61dc21746b94f2f5c70f6585e12afd7681" => :catalina
    sha256 "88f22a0a0afda453cc6cfc26c3f61889e980c26be42515cb1908fa2747f8e9d0" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/gping google.com")
    r.winsize = [80, 130]
    sleep 1
    w.write "q"

    screenlog = r.read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub! /\e\[([;\d]+)?m/, ""

    assert_match "Pinging", screenlog
    assert_match "google.com", screenlog
  ensure
    Process.kill("TERM", pid)
  end
end
