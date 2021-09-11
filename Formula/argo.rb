class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.1.10",
      revision: "2730a51a203d6b587db5fe43a0e3de018a35dbd8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1d1d418be9e25d80721663bd1a512316e2b265757f7bd6d14408d73e858e5395"
    sha256 cellar: :any_skip_relocation, big_sur:       "2a4284a5c3f3bb5857701b25274921f0d7d8401055b602a85e477e867d57806c"
    sha256 cellar: :any_skip_relocation, catalina:      "c7f200c5422af18154b0c6e9889115b13f15fc317072cce3f3940a3efbd7d1b9"
    sha256 cellar: :any_skip_relocation, mojave:        "ed95b263bf9f5995657447c99c9670b6bcdbff2f1bd836384c49ffaf6162890f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f1716405be235298b83f73bc0d93228c18408581a2ccd5d1a73d5aee501c5df"
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
