class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "59a87b9d0bb0f5010d53f0ac72ddee9fd7b5a4039bce51b94b262313e946df02"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9f6eb37d75b01b22db80d6588efdf7b54f4da46014b77011cadf40c066765540"
    sha256 cellar: :any,                 arm64_big_sur:  "4025f975437407ca14fdf443a9fafeb3e9b608d995174b692916cf8364769d3b"
    sha256 cellar: :any,                 monterey:       "6372ffb8ef569fdee3a9c2d6844656a22488632fc00c242b182fc1cef471b17b"
    sha256 cellar: :any,                 big_sur:        "97bcb3fbadef609666ccec59416b49fa11b2df99c8bfde0f755e073a5aa727b3"
    sha256 cellar: :any,                 catalina:       "9a7d75b5fab9dced68695fd77babe2e9fe8b4e0968d6255e6edaef47851ef8cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e48afdc303d124af378973459f8c3f3b469a8f97867e3d18f2ea0687305f63d"
  end

  depends_on "coreutils" => :build
  depends_on "gcc"

  fails_with :clang # -ftree-loop-vectorize -flto=12 -s
  # GCC 10 at least is required
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with gcc: "8"
  fails_with gcc: "9"

  def install
    system "make", "CXX=#{ENV.cxx}", "STRIP=true"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    config = (testpath/".config/btop")
    mkdir config/"themes"
    (config/"btop.conf").write <<~EOS
      #? Config file for btop v. #{version}

      update_ms=2000
      log_level=DEBUG
    EOS

    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/btop")
    r.winsize = [80, 130]
    sleep 5
    w.write "q"

    log = (config/"btop.log").read
    assert_match "===> btop++ v.#{version}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
