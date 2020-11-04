class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.3.tar.gz"
  sha256 "b6c24ee58efde1195c7ef9105450504da34cf67edca424e393d8a2f772f1ec45"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url "https://github.com/kdheepak/taskwarrior-tui/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6dd7aa94ec6660f9a801932095732d0d4aa4754ab8cb80c8c3d2a2ef92e19eae" => :catalina
    sha256 "4ad2a319a8591fa87ed612b004ef9930eaa76b563b7a4c44db563a9386e8313a" => :mojave
    sha256 "a887400278f02386c0e0bce5c77971a8b93b4ae9a71c9e36dfea9519d6a714cb" => :high_sierra
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
