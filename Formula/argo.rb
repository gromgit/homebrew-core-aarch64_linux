class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.12.2",
      revision: "7868e723704bcfe1b943bc076c2e0b83777d6267"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cd220e313e089a39215c043e58f0bf3ad92dd687269a2408aa01ca92cace752" => :big_sur
    sha256 "59ec4a973bcfbe35d044212ec53d97d43cc1bad7fbd9eae55dbae54b823a362e" => :catalina
    sha256 "e594c49c8e0af1abf873b5ae8ca12c92af866ab5f93dd2f4ab3fc5893ce0bcfe" => :mojave
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
