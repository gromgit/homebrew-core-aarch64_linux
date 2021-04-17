class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.0.1",
      revision: "33eaf11e3abd8c761c726e815cbb4b6af7dcb030"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b842b7014c190666058f7811a6b608975fb32e2678d4b7da277686e6dc2ab1a"
    sha256 cellar: :any_skip_relocation, big_sur:       "c03794acfa76ef5871535abb05bf4a90ebda5a6ee61b89175e89923528e5bb5d"
    sha256 cellar: :any_skip_relocation, catalina:      "caa367e3d172fe04cdda248c99c113f9bf7f624ce5f52d96a2bf843a33f63986"
    sha256 cellar: :any_skip_relocation, mojave:        "9b06e512360004adbf20c5ed2fa5137c37d7a691b5c3b867595d2be28d21fcdf"
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
