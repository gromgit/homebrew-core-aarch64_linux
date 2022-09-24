class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.7.0.tar.gz"
  sha256 "56f6544389c168b7876c0fa31d6c780436fc6bcc51ff295e1cb64d1100340caf"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b40f6e7a19d0a279265ba87f13e91a851909be0116fcb5792259a8e345262e5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ad679c9e723d742509704128f0318dbe4021640b60c83633966956c693d4fd6"
    sha256 cellar: :any_skip_relocation, monterey:       "d35e80caa4b91400a26c08bfbdcf462f341ee8e4826b5fb76d7376cf2ac2aef1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e18915274975ac722b60712b413e67c983af354fb445719a796f31182112ea0e"
    sha256 cellar: :any_skip_relocation, catalina:       "9da51345ba2d8db3052491c31b5eb12471c7c99d677e7b08a1b34e7cacc2857a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f4d5a9ab1d171fd4e2aab8f42260643cf2d60ca7f9d394f34ff211dc3a96d0c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
