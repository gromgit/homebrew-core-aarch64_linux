class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v3.0.7",
      revision: "e79e7ccda747fa4487bf889142c744457c26e9f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea3d9dd62a713ab36ec24b61b7ef04ef54a457f914de940c7b434f2c36ceaaea"
    sha256 cellar: :any_skip_relocation, big_sur:       "004b305266765554e161b707300337fdcc59d127c93e044b658f5297abdf5bb4"
    sha256 cellar: :any_skip_relocation, catalina:      "75450503a2e0c7b2d55f429f6086d8bc731ed89d431f1a68646ca4577e143150"
    sha256 cellar: :any_skip_relocation, mojave:        "c0bfe189479134411a7d8055c32c2cae67138fdb17205bd740c128b70b026186"
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
