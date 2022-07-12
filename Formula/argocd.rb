class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.5",
      revision: "0232073ccffa0348f633a8a1fce0b55c3a56a688"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f44e9e1ae531f6317fad521eb3235f08ce906acf12e861ee177c8a8382036f2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dc5d25f87f8805ab41fc0669f3cb1199641c5f4872e41a4f52ce83359c58d7c"
    sha256 cellar: :any_skip_relocation, monterey:       "8340967ba972fdc48c16b2c6cc3f2ef1bc88b5fa024ab2ca3884080007e3258e"
    sha256 cellar: :any_skip_relocation, big_sur:        "74ce5fde2306be5be86f2493763bf623f39dee9df0e0eb48dea50f4d71235ad6"
    sha256 cellar: :any_skip_relocation, catalina:       "a7641acfb52773923ab1edce21cf48a126383917f37972641685d10255688114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "287a43e7195f9fc736d9dc91bde2704a58bdba5c3433ef01b2cac51c947f76ea"
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
