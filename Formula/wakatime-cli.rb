class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.42.1",
    revision: "3e420b08d23a0b709ca3062bcb9342ecaa498f49"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5631c3e671f5ed1a694451ee6d0bad44129951e78bfef99bdabd28797358efba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5f2c1f1161af780e9cf08e7d87e928fd27ee26a9502c5baedfbe5f7acdf679a"
    sha256 cellar: :any_skip_relocation, monterey:       "b6b9f5951f8979307824f129a45546b2e218527702f4d1efda21833e6684a4df"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b7506295a5927c8d13d529f7be83e0ffaef083311d2e47ac02dda87d922c072"
    sha256 cellar: :any_skip_relocation, catalina:       "f99c5be3e7069c20fb75c57ad502fdb4232cf2a37026a6524ddb437ebbda881f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f6cdedf377f014de4e0695180c45d0f659bdc44a83776523751d55de5f11b64"
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
