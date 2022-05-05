class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.44.0",
    revision: "c81cc0f3d9833453c88f2e959eadf2bca325d662"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9409d2962406666dcc76f31c95598d172b36424da435cabc990ef87a249e923e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "782bad0eb4d4c294c3604463663891f044307d58258ee027c0051af28410e834"
    sha256 cellar: :any_skip_relocation, monterey:       "26c5d21777a2f95da753966c2298afd99c5f42c61f9de4611fde65d8d212cfcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "454ec02a875eccf124b169394665790358bfcc7b615eb4e1b72bbc261ace6d0b"
    sha256 cellar: :any_skip_relocation, catalina:       "70c05b7e4655c109dc8e608efbfb1200bb1c95aea33f04a727f363a63192875c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbc2d4f95e4cf4e00e7ee13faf239c5389fab6e1876d47e4d9037bdee0dfb0f2"
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
