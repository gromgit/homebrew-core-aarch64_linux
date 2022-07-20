class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "390f0580bf2d4a92e8b4d4f3d68187a89ce602f73693ffe6b4a0c432135c9bbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e0d1e4ceaf0082004b78d138efe0d9f8ba77cea3f51f0aa6d143dc6b2579a0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97df3f06416361eb429f5d77b2c63b2da86f07c8836aee0d5ff7efa942859c67"
    sha256 cellar: :any_skip_relocation, monterey:       "e894e29d4be7aca3322e86d5053fa727b013ababc5c9b63cf4dee52faa87fcd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "429d4fc247cec3bc23aecaa29518cf8d706d1f2e15e0af26fbd5d10cb25ca1ac"
    sha256 cellar: :any_skip_relocation, catalina:       "72a230cc9a30867d199d46993be2c172f5479484fff3e555dbfcfaf7b1e2f30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53b166007ab751013a763d6fed79d7d75cfafb0e24bbea5d95e0a88f58d70971"
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
