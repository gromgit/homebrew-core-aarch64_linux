class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.48.1",
    revision: "8a5e8e6337964ac3e8108a4b0a38c8c7a5d75b3b"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88fdcc816d5edaf0a37c1ed10b1f0e2b782626dc13fb6e73052a30fc0b7bade4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c52ea289d4b028abbf44dbf2abb9388a2c24c3912ca1475c1de9f28c84d9f00e"
    sha256 cellar: :any_skip_relocation, monterey:       "f8fc67a2b305ef2d951f080703d9acaed97c0b26ad940cb4f7a9cfba8dc855f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f80b2854c0e0ecb1d52bb7a7a88f231fab79a3eaeb11b1fff80af38492f8b6b"
    sha256 cellar: :any_skip_relocation, catalina:       "848e67010c9dbcbbad8242853b72f543d8abbdabf5dca2e680ee439c1ad775a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "085bdd4508544d693fd45bb7c9349b7c3651b7d3dab8f2bc23b76adf40faf414"
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
