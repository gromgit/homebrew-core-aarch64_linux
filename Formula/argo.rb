class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.3.6",
      revision: "2b428be8001a9d5d232dbd52d7e902812107eb28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0ccf381a13ba9b67fdfe269b3bad7b9eb4ec9bc306b45ef31dd5d21bf05ff37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0aeb16dfe77c620695d97ebaa30656a3afe3025aa5f19940fef084cfddad1d0"
    sha256 cellar: :any_skip_relocation, monterey:       "4e82c353637803c191fbfdfa0894ea3de75353859b4e1cc3009b5dda76fd9b0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f58bfee60f24b95885b5f9f4efb275a0c702a15bcf71fef4cf21a2c213ab31a2"
    sha256 cellar: :any_skip_relocation, catalina:       "8fd4612f039b80b13609188d1bf9f4054cf671e2fe6cad34cb1027c5525079ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdeae8f36305f712ccab03153d47de86ef8a566a8aeaf7a15e41e0bad7257bfc"
  end

  depends_on "go" => :build
  depends_on "node@14" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    output = Utils.safe_popen_read("#{bin}/argo", "completion", "bash")
    (bash_completion/"argo").write output
    output = Utils.safe_popen_read("#{bin}/argo", "completion", "zsh")
    (zsh_completion/"_argo").write output
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
