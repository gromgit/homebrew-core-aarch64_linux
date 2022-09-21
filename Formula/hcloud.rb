class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.29.5.tar.gz"
  sha256 "8a8a0a8ee86eaae329090657f236c8f736c5c67209fedf5047977f8ef8c2afb8"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/hcloud"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c90c0c43de0382c7f7c9965db59c96283e50e39f4cc3fe1dff72f4052e893f33"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hcloud"

    output = Utils.safe_popen_read(bin/"hcloud", "completion", "bash")
    (bash_completion/"hcloud").write output
    output = Utils.safe_popen_read(bin/"hcloud", "completion", "zsh")
    (zsh_completion/"_hcloud").write output
    output = Utils.safe_popen_read(bin/"hcloud", "completion", "fish")
    (fish_completion/"hcloud.fish").write output
  end

  test do
    config_path = testpath/".config/hcloud/cli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}/hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}/hcloud context list")
    assert_match "test", shell_output("#{bin}/hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}/hcloud version")
  end
end
