class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.4.1",
      revision: "0546fef0b096d84c9e3362d2b241614e743ebe97"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7d0ef1ff6b105077b5b1579df9df3837f7bbdd4f10f6626aa3506b41a76e870"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27c006ba2571b875155e437acd04a6038be122659485111779ee3abe67125770"
    sha256 cellar: :any_skip_relocation, monterey:       "338e9164532218d1fee417c2e8dd9ab5d554c3324faf7e81126f94af0d5b0a34"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc45feeee0753696f67c4900606d7699779e0c2c10befc8c3832b20143935946"
    sha256 cellar: :any_skip_relocation, catalina:       "7d09c0afc8cbe7a990ad1dfcf8e3d843a62ac32eb8c40d4b79edd039effd35e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ba8ca76a8211d0cd579f7caee34b72791a55134ba843442d0473b9897ef1602"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argo:",
      shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
