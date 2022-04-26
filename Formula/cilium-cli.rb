class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "52f6e5006ccef7d869dc98becc631a28b3755a212a7d63beb52cba9f504a4aa3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d095865ead73248d6a70f76dfe18fb591d42a701b532c52cb1412285cde57735"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "621510a4e6fb232a4eaa54f55c9e90924c28b53178a326c41438df1a4dcd48f7"
    sha256 cellar: :any_skip_relocation, monterey:       "a16c918fb36ef86ba982d9ff09bbb96bd28e544e54083e6519cd1357d9ac52a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "40a6bc1948a74d4494e930c123f0ec814ce5c01ab46ec74808e2c2f1fc3d10a8"
    sha256 cellar: :any_skip_relocation, catalina:       "d8763b7c8dba73de07a25447de89532ae599e92ebdd18150d0b7d0192805fd5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e394325334bd3901491c13acfc653825b593212544ca8d17cb8daf04979499c"
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
