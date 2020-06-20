class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.16.0.tar.gz"
  sha256 "25d7d7f188a5a5698e396f6735a66223b84e2101145e16c4787cf2efc93b9e4b"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "608f0087b5fb006acb33d6f479d8c58fc9827c0e32e6230e66b28188d0a330d9" => :catalina
    sha256 "6a609e1a8becf0ee843e89ecc79fc685879f79c6643b7df54ccbe1e14c37ee76" => :mojave
    sha256 "c43701adf5d10fe6e31632a2569bc02e0ca7585087e2381f8a1bd5f7c715d0c8" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", :err => :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
