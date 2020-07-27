class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v0.19.2.tar.gz"
  sha256 "7d26392e1e70d382d20ef478a2dfa093c410f8db2d2689615c89cf3f69166063"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3f18be739e6e3334bcdbe84314e4a2860ed415f5cc7e28a1166ddc08f1b8adc" => :catalina
    sha256 "3380a451847cae780b8e6a9d0bc03d07f8989b518e5d8218f044c18ad0a55f18" => :mojave
    sha256 "b989cd27989ce6172ffd9d859ca0f216791e6b7ccb37a79592cf1f7432794b85" => :high_sierra
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
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", :err => :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
