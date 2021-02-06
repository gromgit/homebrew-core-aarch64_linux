class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.10.tar.gz"
  sha256 "b72d2e55fba6575901d958fa44c9845244fb4e8f73fc72ec736db6148750a040"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8785eca8127040523fa097a83664d12a9e8fc0ec2946cc96e7869da6e2278e7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "38bcceb2b4a6fe3418262576aa39983e1ceef99142efb65337ac2d8afa18bd2c"
    sha256 cellar: :any_skip_relocation, catalina:      "4af59d9eed58f93bc210822c626006f77f780dd89cf13332e7fe71f3c86ed026"
    sha256 cellar: :any_skip_relocation, mojave:        "3d5fdb847c563d8a56dd93e2bf6a35ccf43de4d649b587b4ce57c4634d5cb769"
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
