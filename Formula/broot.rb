class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v0.20.1.tar.gz"
  sha256 "02581a45088e0bab3706ae907fd9100de48c59f60eaa2ff38b1c1f9d54ba94af"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2cd4dd7fd1b6288d3026b4558278950b07c52df22e849afb0e69a427e313f4b" => :catalina
    sha256 "c41f2c93d2230edc2ec1d93194b030e2f90d72c36c7b34e201a6c4719f5f3d75" => :mojave
    sha256 "68dfd158f0862f9500fb354c5c8909a6a1aa1f245d692067895ebc02ff47f67b" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
