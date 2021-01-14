class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.2.0.tar.gz"
  sha256 "87758fd6bc4bc3db32d6a557b84db28fa527be2102ecf9c465cb5a0393af428f"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ae4efe3152f1b17d42bc0b6846ea6eb7e29e097a6dfb9a92bfb8689693159cc" => :big_sur
    sha256 "163fa3273c7dc0e5544ad8957f670dc412093d7ab470b12e74e68adcb2936d78" => :arm64_big_sur
    sha256 "4384041bdd4c24be4fc62ef194807c11156c1d61245b8179415f196dbea3edd9" => :catalina
    sha256 "d68725ff4500e500e112378cb975a3fa07219a11b026a692f835e9eb869a1df6" => :mojave
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
