class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.44.0",
    revision: "c81cc0f3d9833453c88f2e959eadf2bca325d662"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c2f03c93eda98a411bdc7ebefd77e0be07077b5278f5d6c0d2474c838257738"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afe20c7d77f4cd7205b8c5746cd839e5cb56891064914971c28c60d2938ea442"
    sha256 cellar: :any_skip_relocation, monterey:       "7ee9670c654b6353cdfd9429c961f2ea6a5c93d1020f773be043880dd8a9359c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcede8090d2c3790269c905c49a5207c13177df0d1095ae51864292a8190f65f"
    sha256 cellar: :any_skip_relocation, catalina:       "19046615bc26573e473d8522874b5730e725b049d4c8baa5365b0b1b611ce521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a6b3c2269689608f3ff92bead4b7e8073d668c70d945b3422c235ad14243805"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
