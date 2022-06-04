class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "f1becdf87c0f1cfedcf206297f9f2371d31bc467b6c3f6d35af074c73f5d30ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a6e39e2dc00c8fa98759218c2c1ac53f2d25561e010e30f7cbd3e7bc4498c6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa2efa383286b79adf5148d5afbef7cddc24826d1f97385421becaa045f46863"
    sha256 cellar: :any_skip_relocation, monterey:       "a647492975c3ca5d6ffd1c5e1c187d16d89c2fa1c329145e9a9ece652b368eec"
    sha256 cellar: :any_skip_relocation, big_sur:        "449e7496fb13d02a7bef0a784525d87b05d312bb88ef72b19cfb8ff9a704de8e"
    sha256 cellar: :any_skip_relocation, catalina:       "f993c3d8799b2845d72be4cc8821e3e22f5a6d4c00730d763b73a0241aa1efa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2393172695ec1e1525b31d1b545a8bbf4616b42b6e400dd92e46b6e0c4ec1b12"
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
