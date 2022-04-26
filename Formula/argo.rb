class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.3.3",
      revision: "9c08aedc880026161d394207acbac0f64db29a53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b93857d5b0cd12d645f6be7798852e540837eb47fb53d0f51a6cbdfc7ee9baa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57215123f9209f29d720d5f89e38cebbba6b991c52b3337336be3a5072f0fb81"
    sha256 cellar: :any_skip_relocation, monterey:       "aa1da5a255c66ea9c7da723960d7aa6b37b308e6ae237fbd3477572217ef0424"
    sha256 cellar: :any_skip_relocation, big_sur:        "9416e16ca3874c8347a64a6f425e5d10f70af679de282dd4bad3769a933ff8cc"
    sha256 cellar: :any_skip_relocation, catalina:       "d44e325d45a64cf1075b81199730051797adc7f38c2b1f0bf7c22c09ae505b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96a6459a9244202236aab46f1096dc1afb2b10a34c70a33c12a41c7f07db7508"
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
