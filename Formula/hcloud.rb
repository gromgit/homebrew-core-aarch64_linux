class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.25.0.tar.gz"
  sha256 "e9f78dc6194c3d43202910409f3f7ce7184171dab73093eb13280814b17b149e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "82d19b10b267039429b75f0dd7aaae00c28572d4838d1536f1f26779c075f78b"
    sha256 cellar: :any_skip_relocation, big_sur:       "332ac8bdf5dd7cfb17d7bf10b454c384766ebc5e554a99a4c51ffd508ec1d889"
    sha256 cellar: :any_skip_relocation, catalina:      "7a05179cdb306920d30cf93babc4b2b06c94d83d39ae8d01cf2d875549b4996a"
    sha256 cellar: :any_skip_relocation, mojave:        "9784796504ea3ab242d89ae7136c2f0fe72e9e9ea0bbc2291b9cad3ecac4335c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/hcloud"

    output = Utils.safe_popen_read("#{bin}/hcloud", "completion", "bash")
    (bash_completion/"hcloud").write output
    output = Utils.safe_popen_read("#{bin}/hcloud", "completion", "zsh")
    (zsh_completion/"_hcloud").write output
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
