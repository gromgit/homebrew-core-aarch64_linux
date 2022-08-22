class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.11",
      revision: "3d9e9f2f95b7801b90377ecfc4073e5f0f07205b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14783c26fec883a6395c2445122b25c800c006e07e46eb6d90e64e7ca5afb8a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b4a37f1489c17f0a4a3283559d38d2c356a5b8347127fd35eb21e0b6021e437"
    sha256 cellar: :any_skip_relocation, monterey:       "09481500562cd86958fd3efc7eea63658d697d00881f0992baa4dc6e0a82d03b"
    sha256 cellar: :any_skip_relocation, big_sur:        "331ba8a5ac5a316a36c95575dd4241bd395cb2866f8303db381f6cf0423df669"
    sha256 cellar: :any_skip_relocation, catalina:       "a0e788c8bcb79dcf792aedc8bd101e43080a7c0aba1f08c3a49163e776dd6567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f134f54d009a6370d22877a9e5ecf066ab7443241810ae67cbb43f45c9f99bce"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "dep-ui-local"
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      system "yarn", "--cwd", "ui", "build"
    end
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
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
