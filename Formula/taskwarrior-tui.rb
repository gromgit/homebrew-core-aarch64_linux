class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.12.tar.gz"
  sha256 "012f9cfdfe23ccd428ff6590c35ad3e6d6f3c14d4a1259598bbddeb6796f70a6"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b5a2c4e3cc139ee5e88c7b6ec41ab0e67607ed7e56c4583650e64c5bfa2f30ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c1bca824b073c62b92aff868780a31909ec894799c374f097278ec601fc76bc"
    sha256 cellar: :any_skip_relocation, catalina:      "82031c03f7ff464dae2af9c6770c5625f78cf38c788b073c4075d9d807766d9f"
    sha256 cellar: :any_skip_relocation, mojave:        "7e442fd4b1e03828bf536e1de0c46d0dc3bc31102c1a7cdf9253261ea976d251"
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
