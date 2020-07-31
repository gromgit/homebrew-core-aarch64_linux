class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v0.19.4.tar.gz"
  sha256 "839f9a2808e35ae78b184310e4c6940908dca2dd117b02c50bf55e5322efd3e1"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "105de591ba1275568026ed36ef815a0e5d54bfab1639e768b9e9469634bc7463" => :catalina
    sha256 "106a9649868b05d55dc6169483d0707bd51c22e47897b96cd435f051b3685dfd" => :mojave
    sha256 "172251184c326bd7aadf671fd62e3521b51f229349d2f1fa5df0656de8206634" => :high_sierra
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
