class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "4949d50b4e7003e7c041c98d2c8f3fc78e47ae4a69d117e1879961e79708b77b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97172a1e172abdbaa9f9055e5405d950dd66578facea65a62bc0615a06464d06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87e11096061e55735214984ffaceb7eecf22117c53db732f4dc7c2849b4b8a72"
    sha256 cellar: :any_skip_relocation, monterey:       "6a0084e90275145dfd72d110b14c05ebe52ad17952e60e0dafc0047958be15fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c1ecba99435ed4e386a796afe82b98c9820859e9902dcecb9b547a8ddb0dad8"
    sha256 cellar: :any_skip_relocation, catalina:       "6401db8c779c42aea998b140f9d0377317ea69ced0164abab2553ce918bf8a11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4804e4ebab5718df03975347028e27c540d9a75c73aed77485f07fa19b488d4"
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
