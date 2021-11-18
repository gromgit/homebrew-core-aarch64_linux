class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.2.4",
      revision: "8771ca279c329753e420dbdd986a9c914876b151"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c61ec0627f145e16a54b9db8a1e78838064fc36951a65a00cf43040d663ef008"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "654ef290a58438e2291b50be164dbe147af14563566197319163b373ec752bd0"
    sha256 cellar: :any_skip_relocation, monterey:       "952281ce3dc5c39e34b7296f3397af3532604029ca6619e40d4201644749882b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9339723eee46c58b91e8bb84e62df5ce363434931170ceee127a0da5b27512ee"
    sha256 cellar: :any_skip_relocation, catalina:       "4dc0af4cf26cea93e0342947b7a5eafca1eafa5db8daca5270890cc92b77e48f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8a812d2f6cf3ac1c3485edbb45f4ae4df985bd4b22d9b4547822d122d01f1fb"
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
