class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "4949d50b4e7003e7c041c98d2c8f3fc78e47ae4a69d117e1879961e79708b77b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ec0955ab5e6d1012b6433f62c85d19ea71bd0fccd5668e87f7e46de1d3f0db7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b6439f04f4b95be269f75044e5663105e1f21e831c0da08548437ca509a8754"
    sha256 cellar: :any_skip_relocation, monterey:       "14a83d78d87c6a7eb4e108e3c93f261d8ae4524ff9595fea1f174c31be3d765d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1145b8c38de3689f439de793d97c745502f443cb85d04715b6135b3e2c85b356"
    sha256 cellar: :any_skip_relocation, catalina:       "e4b20e93d6406bb5dd100e2a9b53c6826a3b3d86a8ba46f80441cc91bb70110e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1aa22c5c84ea19023790edd9198cf71dd7aea45110c75ac8163630d2120fdbd"
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
