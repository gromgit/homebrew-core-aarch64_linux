class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.1.13",
      revision: "78cd6918a8753a8448ed147b875588d56bd26252"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ed38857e493961f982566fecda0013f3495315b9357dc877296ae7b1b29fcaef"
    sha256 cellar: :any_skip_relocation, big_sur:       "c2b90930dfbd7c256f75064557c0c818c78877f56fff4d6a72eb3c3904e791d8"
    sha256 cellar: :any_skip_relocation, catalina:      "832c76c8ce611947390afe883ff12c4febe86f3394bcd9b5feffe6060a9ddbec"
    sha256 cellar: :any_skip_relocation, mojave:        "6c400c01fab612a7446bc027603c145d4bdc7d611204866e00bb4144fbb5a08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9343a9a4ae2ef37bcc424d9c1b763f5118ef3a49d19769b0004d3fb2eded92d1"
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
