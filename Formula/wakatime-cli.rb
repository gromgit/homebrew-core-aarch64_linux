class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.48.1",
    revision: "8a5e8e6337964ac3e8108a4b0a38c8c7a5d75b3b"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bcd786ea30756ea21fcdc3b38c51a0a819a4942c6a9587098e929b7263568c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dde6064ebab21f491ead5a3ae60310ae495b1bc0ecf68383f35675abc10bcc20"
    sha256 cellar: :any_skip_relocation, monterey:       "278038b26e575477e34c2ec38672a9203c3eb0223eeac1cea282d5128715539c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e4dca3bf6c2197d10385d3d934addc61a6de6eea75954ac1fac1ea4041b3555"
    sha256 cellar: :any_skip_relocation, catalina:       "2dec98daea47344e6d04e51dfd1771b09d52c634c67f7b2c0e9474541220e8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cce5e5f11796a03c55bc622a1aafc25e3079a1b65193f013029bde528c5dc38"
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
