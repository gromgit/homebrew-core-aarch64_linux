class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.7.7",
      revision: "33c93aea0b9ee3d02fb9703cd82cecce3540e954"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bc60f72a3e335e455fdbd22e696b49acb3990622141eca7646da78afde0c7b8" => :catalina
    sha256 "a212555e17e87aa4c5e1e56c621b830ad40f303502ea493791c1b366a261d5a2" => :mojave
    sha256 "5c6866aaade97340ba822d82870b2be585fdbe4ea14c8a7f026d42aad92fb2ba" => :high_sierra
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
