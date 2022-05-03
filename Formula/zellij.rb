class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.29.1.tar.gz"
  sha256 "340f5241c9b1abb5652b1531167f837fc573b9cfdefa551363a48930f8f1d4dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "887b48b35e24fcc53216b96b12a1b882efa34a3361b4a921f5dcab2b86d2e577"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffaee40f51086c130a8196a097969254be903d37d570a3e94c87c098508dc452"
    sha256 cellar: :any_skip_relocation, monterey:       "a38b73bac3096c440ca6ed330c1e5fbe62de9988ad8b8ac6c0894fdaf8ae7365"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e3499026db5d7295c2e5b3472c119069c54579133ae21c904effb1e1926d3d6"
    sha256 cellar: :any_skip_relocation, catalina:       "2e61c62b23846111f757cc0f5b1da8273ab60c34bb8dae260cd7ca3c66a2c569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d39e3c5bc1ba1d8d50b7811238da3f38c0bfcaa458e3274f6ed22d86f0460c06"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "bash")
    (bash_completion/"zellij").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "zsh")
    (zsh_completion/"_zellij").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "fish")
    (fish_completion/"zellij.fish").write fish_output
  end

  test do
    assert_match(/keybinds:.*/, shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
