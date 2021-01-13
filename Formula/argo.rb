class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.12.4",
      revision: "f97bef5d00361f3d1cbb8574f7f6adf632673008"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5bff14f5f843c0358e9cfe4a7dfb082001e1ad504ff8496656b46ceffd5b9e2" => :big_sur
    sha256 "934bd45bd10fd081aa2b04a086ff8302a391a9415bc47b3eb69c19b0068267a7" => :catalina
    sha256 "88858af5b9516d07a86bbaf9e9409be2778da77c24c1e448432d876c623df685" => :mojave
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
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
