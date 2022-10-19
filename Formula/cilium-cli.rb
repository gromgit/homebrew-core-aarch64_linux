class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.12.5.tar.gz"
  sha256 "24b0fae89cde90b86a23f1b0858ff810835fe05c0c96e369a70d018345edd9cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25c92248f27c5c5e890ad44adc4feb7353aa17109d484d5fafb007e7e3f2f794"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aef004a97c85ebdb91a2bd89598de6af38a63a1a78dad6d0be27e75c832284cf"
    sha256 cellar: :any_skip_relocation, monterey:       "9e9aa1a1d395e79a4db6fe16848519c01542131588d96b7ee25fd6df28d840c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e681f324dafacc919ccbfd52319ef1454c6450744ee5a337159bb0bb1dd891b"
    sha256 cellar: :any_skip_relocation, catalina:       "5b718eb1f0bd2c3151d5e024ead0e781bd4cc5766e7e5b2af2d33dfb24f8af0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7610af499eea74e46b7c5ef1492880a382c7079704b447047a7b7ef8d381fbcc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
