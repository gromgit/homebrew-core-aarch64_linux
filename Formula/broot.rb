class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.0.3.tar.gz"
  sha256 "24f648e9e1db12f5e4e2231992da0b7903e6506ad0c533e0a2e8e336a4b3a6de"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "71ce8bc9f41374fd4df9b6d868862340ef6c8c7b2f565a388f366cb38f82e487" => :catalina
    sha256 "a87934db32c00ddd0ed868ccc152f50584ecc136c7c8f490a7f160cf8d84fe96" => :mojave
    sha256 "05aa251e5d1d294d32c73ddb3d473eb07fb1c74972ddddc9215efe4f5fc44261" => :high_sierra
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
