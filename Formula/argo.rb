class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.3.5",
      revision: "eefc60b155c4011a3706d2e3cba90f099ee93b39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cd42c81aff4eba66a5eecf53cc37e6b3844b6215ca20ec181ecbf39bfab6548"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61daf81f0946f813d204f8d8500d64432bc09a313abe2c52123483c7c677e047"
    sha256 cellar: :any_skip_relocation, monterey:       "309ff57c4ffcad4f7e8d7578702d1ffbdbc5fd69104c18dc3192d8acffdf9d52"
    sha256 cellar: :any_skip_relocation, big_sur:        "c060ff22c2e6cbcfc09d783638b969bfb6bf4ca4b6b9f644bc3fc6fc2db8aca4"
    sha256 cellar: :any_skip_relocation, catalina:       "29ad7a29252f79d29357c25292844e2a45cbfd67c7bc4d7647dd50fd0b9a7309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfa28939c72a065b082438b3e1a3763bda48d503186289071ce9073daf5a1d9b"
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
