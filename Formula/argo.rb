class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.11.1",
      revision: "13b51d569d580ab9493e977fe2944889784d2a0a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab40134980297fde1170d77bdc07f3685d0bb7b4f846e9c2b847f07796f2e0f7" => :catalina
    sha256 "c7125f460fd23b59c39a2dfd10af8239fc1b6b7cae8a85e72d8d1b75b45cb69d" => :mojave
    sha256 "aadf80347cdb807d56594e4f7200b4dc7c600f8adedfe6055e150df75596466a" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node" => :build
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
    assert_match "argo is the command line interface to Argo",
      shell_output("#{bin}/argo --help")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
