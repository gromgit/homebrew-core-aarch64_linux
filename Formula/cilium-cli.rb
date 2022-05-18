class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.11.7.tar.gz"
  sha256 "1cfe549243b97ab781401e34730df6a28ddb31d359b017cc834f8ef1228ffcb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a04d7c35bdf614fd033402c28fcbb91a9608760d6d14fd520074574257fb291c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a802eb6ce68a3189288736acd301d83ca36bf090d85c49a2f39ec907bad85da"
    sha256 cellar: :any_skip_relocation, monterey:       "a469382992308364be39b109ee3f3cf21c28edd7a5f866ff89ac588e6f0f04fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7ccabaf49dbbd26eea5a246b25c3989cfc21e10dc260103f447d0eb69c576b2"
    sha256 cellar: :any_skip_relocation, catalina:       "30eb9b74549a14051da25e0f1a8595096de3da956a65ded7d0a4285de26f14cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97db0c44b00574518c11adc1f386981157d2b5d797999f5db51297f69535fd87"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    bash_output = Utils.safe_popen_read(bin/"cilium", "completion", "bash")
    (bash_completion/"cilium").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"cilium", "completion", "zsh")
    (zsh_completion/"_cilium").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"cilium", "completion", "fish")
    (fish_completion/"cilium.fish").write fish_output
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
