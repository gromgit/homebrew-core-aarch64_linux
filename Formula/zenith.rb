class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/0.12.0b.tar.gz"
  version "0.12.0b"
  sha256 "ba4896d3018264804192daf1e7aa979d31c3acd5d05a8d966301fe3993f3916d"
  license "MIT"
  head "https://github.com/bvaisvil/zenith.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "10d0e8574d75d016be840a964d18cc8f82f52c0760567a9d57833cb7594d1bb6" => :big_sur
    sha256 "3df65b399605f942fb94570bb90a82b7c1007481a6b0e65e395a63b2556cf9f8" => :arm64_big_sur
    sha256 "13b1aac8018d96a18b15c8573606ed9acb58ee6b90727005e756f6587a061a59" => :catalina
    sha256 "d271ee30aa033bcdb66d3b7d8c22e13344efb5e8605cb89d27e3b9f40403beba" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"zenith").mkdir
    r, w, pid = PTY.spawn "#{bin}/zenith --db zenith"
    r.winsize = [80, 43]
    sleep 1
    w.write "q"
    assert_match /PID\s+USER\s+P\s+N\s+↓CPU%\s+MEM%/, r.read
  ensure
    Process.kill("TERM", pid)
  end
end
