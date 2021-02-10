class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.14.tar.gz"
  sha256 "5b1e8d397479b4b50a7535539a5efe991baf588dfca071c720e7d7d8521657ac"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "65c2d8082277750b7c76c6e0cb3d178cda735ecdb7bdd2a1001a6bfc856f1485"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a40a72ceb428cf021334b1558c7dcf5a932b6ce27e6f6342570192e3d6bb688"
    sha256 cellar: :any_skip_relocation, catalina:      "0c6b35f05166d688241642f8cae4eb3a2fc4928091aee917828b0f97ef0dbdbb"
    sha256 cellar: :any_skip_relocation, mojave:        "4be9cf1a2efc31991d2b537108f107e499c78bc68c219331f9c3cc2da5d88263"
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
