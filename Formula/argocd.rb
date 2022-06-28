class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.3",
      revision: "471685feae063c1c2e36a5ff268c4da87c697b85"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fbbbc740ede47b1a8d445ff0ec9cae5694083b19d3e0c4ef300f6d7268d1341"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ee63491845c5bc33507ee7251cb6bf708a1539a5a3045a5397690fac66590ec"
    sha256 cellar: :any_skip_relocation, monterey:       "1daa69e018194aa8e7e52fc151b6aa8efa88670cccfeee30a3e95cfcbf482687"
    sha256 cellar: :any_skip_relocation, big_sur:        "3716dbc398d8893e7b80be439e5acf048bcc879e7572ab5ab1d75d01ed7d7fb9"
    sha256 cellar: :any_skip_relocation, catalina:       "70d43996d18e0fab9fdd9b6a056a85d0be8d391bd06857a145f5275dd2ce6fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff5a69086d0244cc4e60fc070a4c8076d14877b0020ba519eb71124831cebdb0"
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
