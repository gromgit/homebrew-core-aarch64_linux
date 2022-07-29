class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.8",
      revision: "844f79eb9d8f3ab96d4ce6f8df211c6093a660ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e7740e8fc72771f101d9068190b68bf92410445fb0a15f561225ec5eaa58062"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb4d4613718cd8857c552c5d7bb35e0b5afa25f90db7c096f13d4149f8d18d0c"
    sha256 cellar: :any_skip_relocation, monterey:       "9c6d50743cdf30190018c514c5908d88b10d2080e3c7969b1aba81515d92dbb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8dc3f81541a6a7a43b3ebf7c44e53e871272f764ac94616459c00e6d827b79f"
    sha256 cellar: :any_skip_relocation, catalina:       "8f192d7db90f50f719749ece5499b343193169bc46e62cdbae4a55a84074310b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09f8760fc2d05bf60bf5f45f513c5d16010c0ad80701409f6b338b1397c66416"
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
