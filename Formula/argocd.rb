class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.1",
      revision: "52e6025f8b565705025d029e8bed36d6caa5ecf7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1ba1a913a9b7e0d162cfb0dab17c18e5a13cfa9aca455ad8ee0ce5531cc25c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f510fdb042d28e43096407ffd51d13b90802e1765b91c89bbf5f35ceb197db3c"
    sha256 cellar: :any_skip_relocation, monterey:       "374d48b57d6640678167da919c548ee9a409a02a5746c27ae84f5e2b418a9ef9"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc377c6ee83754a0c72d331d4c06f7f0ece2fb78b526e5be42ec3fc3b521a9b5"
    sha256 cellar: :any_skip_relocation, catalina:       "8276310a9a0b9e0e02b9ce04190d2cb9674b6ac86323391928a3c0bbe5efcd03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33c71f4d43ef8be923129fe24de237d830980b2abc1cc008a3833f5a6fa32d19"
  end

  depends_on "go" => :build
  depends_on "node@14" => :build
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
