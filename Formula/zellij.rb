class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.23.0.tar.gz"
  sha256 "bb4e1b76f4143c2a65684e5e92cc534e5da93e05434fa50727befda2d95107e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6449f179570d85b04bea886bdf0851b40fcdbe07a7b4b7e3e5edcfce217a4f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d584a024f92da7df4c7ea59dfad355e1c2ac2fec489a0139f02732d108d478e"
    sha256 cellar: :any_skip_relocation, monterey:       "ae3a620680de30e0ba69432e047e8a55a431ea49f287702fbdd200b701298417"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ad704c9725dbcad08bfd0d69a22ebc51d9bd9e0a7caecb64e236b1cdf98dcbd"
    sha256 cellar: :any_skip_relocation, catalina:       "e3d6a09a06d74f04068a74d5b0efdb14657d353d2a48c1433e1dff9f6d814b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05e408ed7cccd6535f0f878a74a779a4bf4264d8668f3d3772a7ebbe58e9d1e3"
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
