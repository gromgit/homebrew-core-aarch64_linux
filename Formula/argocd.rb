class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.7.5",
      revision: "90cc56c3a99127f6ed6bcb777abf92e357c1eb00"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d46322d53c5c2be38a381f5b882eaac63c8821cadc2e51b382e691ffee143097" => :catalina
    sha256 "b2c34e1587f02b4d02899d4795f504f1f99921c3969bcfeacc47674e9ad0ab83" => :mojave
    sha256 "675dfa8e17e3e7f3e42d96de0e3638ad95ec3c221115f73428ccd04dde5d1266" => :high_sierra
  end

  depends_on "go" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "cli-local"
    bin.install "dist/argocd"

    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "bash")
    (bash_completion/"argocd").write output
    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "zsh")
    (zsh_completion/"_argocd").write output
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
