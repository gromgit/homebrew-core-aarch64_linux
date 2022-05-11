class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.45.1",
    revision: "fbcd9d4ef8aa84a7fea0a7b15af4440d4789a1eb"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cda49187377dee064d369fa864d540aa101c0786cbe1d2c91077a75b50d00c12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b731de13c04a8823f1943fff1589b667808deadeb6cdefdc88ee6493f4405d99"
    sha256 cellar: :any_skip_relocation, monterey:       "a826454338271b40d93f7e5e1fdfd8c0209c907043a5f6430bf65a8042e04164"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1af0a9a095a21ea8060aea3273937f73c50bf4c8ff1418530e5ba26cb5bd743"
    sha256 cellar: :any_skip_relocation, catalina:       "e06cd9cedaf3882c81203da199672d43457ce20d0f1f8daa4a570028e103d429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33a2a2808d2ce6e3c82e3271fff07610b955bb13c27f9ce23a666bda37c74b92"
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
