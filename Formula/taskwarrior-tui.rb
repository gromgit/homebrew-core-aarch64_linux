class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.9.tar.gz"
  sha256 "32fbc516ea6843505eefa260d365a28e9554417c9385ab7da9336a9815197014"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "786dcaecf0b830c772fc427e298d200c412152335438f44dabea64ff23fb8792"
    sha256 cellar: :any_skip_relocation, big_sur:       "0914e4321f587db1477b376f624435db1f85b8508b376d6bb96739f3b4fa635d"
    sha256 cellar: :any_skip_relocation, catalina:      "4a29b15adfd3320efd7967e1e0637bce5d73923b02f8a681de63684aae807426"
    sha256 cellar: :any_skip_relocation, mojave:        "70521fadd7ba9ffd30cba47b3e90b5212aa8166e6aa79e10a512b547bc92b1b2"
  end

  depends_on "pandoc" => :build unless Hardware::CPU.arm?
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    unless Hardware::CPU.arm?
      args = %w[
        --standalone
        --to=man
      ]
      system "pandoc", *args, "docs/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
      man1.install "taskwarrior-tui.1"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 1)
  end
end
