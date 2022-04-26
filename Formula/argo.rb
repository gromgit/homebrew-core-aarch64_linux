class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.3.3",
      revision: "9c08aedc880026161d394207acbac0f64db29a53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f99a6d38977ce328f4eb9253280fb001f03214d7f2624f3527de21d946e7d6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "199435908b30861d6e7f3d2863b0c6f2303a61796564fc3b3c01eacf2e87894b"
    sha256 cellar: :any_skip_relocation, monterey:       "38334b7b4058a5087ab83749a5b5b7485aba64ff999a9075d22430835c0cac32"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab323b31eca6c92513df1a1d6756785f3e34807b4b3ef4457d44001c08fe5ac0"
    sha256 cellar: :any_skip_relocation, catalina:       "1813d8e987bba3779a2f53b47d020708d5b01b1335a534996eadf713892feb71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45cb79addd9e03956191b4941bdf439dc9498adeeaeb0b10b0555d19906b7636"
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
