class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.13.2.tar.gz"
  sha256 "094ef8759e9d3e746dd504c5cc9323a8cb954f1690e8494ced6910bf9a710904"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7e01fbb8d92a46ea1eb74361c0c0bae8dd5cc74bc0de936a9fa1ee516da72c3" => :catalina
    sha256 "079b089a9f0bcb60d1dbd9dd2a659d4297183d19e3796e0ea47ec96ca4b82532" => :mojave
    sha256 "628aafa3d01324f29ebf6e979d3961083ae65dc7fccba54fe058df68c28e76e3" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/broot --version")

    assert_match "BFS", shell_output("#{bin}/broot --help 2>&1")

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
