class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.11.0.tar.gz"
  sha256 "18454237b33fa8c23f3e93e2c3c088983ac40a269b572a089e858435640dac40"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a16c4ee64727b03c7f889c7bf5f4054c83bfcebdbc236f41f5957cdcabbbf91"
    sha256 cellar: :any_skip_relocation, big_sur:       "8201359ce540e120ba60fb86d6c182752a983870b8ec2491fcdafab24b313127"
    sha256 cellar: :any_skip_relocation, catalina:      "8201359ce540e120ba60fb86d6c182752a983870b8ec2491fcdafab24b313127"
    sha256 cellar: :any_skip_relocation, mojave:        "8201359ce540e120ba60fb86d6c182752a983870b8ec2491fcdafab24b313127"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/cloudskiff/driftctl/build.env=release
      -X github.com/cloudskiff/driftctl/pkg/version.version=v#{version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "bash")
    (bash_completion/"driftctl").write output

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "zsh")
    (zsh_completion/"_driftctl").write output

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "fish")
    (fish_completion/"driftctl.fish").write output
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/driftctl version")
    assert_match "Invalid AWS Region", shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
