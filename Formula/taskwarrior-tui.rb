class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.0.tar.gz"
  sha256 "591ed30332ad9fab454437666be43bb040b58a1814c5d78c142976b8d0c72027"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url "https://github.com/kdheepak/taskwarrior-tui/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "99d5dc70534dc556b5ee04f65325c1fe1e6edf8e06b050403c77dc12bf24acd3" => :catalina
    sha256 "1ed0f1608949bb581da1ecfdd6dec512b70206e3a4593cddff72542bee66d1ef" => :mojave
    sha256 "2de2c50dffa8368ecda125f685559f685dc10765ca9054083dba732e22bdfe46" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 1)
  end
end
