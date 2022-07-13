class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.6",
      revision: "a48bca03c79b6d63be0c34d6094831bc6916b3bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf490661ca5380c99f2808472045b5f4bd29f6e80b402460aaeec4f655f0ae50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b016a7f0e937a9d3951dfe53f15dca837758a271f77e7927e071d5450d4ea12"
    sha256 cellar: :any_skip_relocation, monterey:       "5bd59457b05ead50c05c20164ec0058e19af2426bd15f9c714ba140f5d3beb53"
    sha256 cellar: :any_skip_relocation, big_sur:        "010fc4156d2d3ae6cb4ba94b133be5743f8abacd78a92e18b16026ee258d933f"
    sha256 cellar: :any_skip_relocation, catalina:       "f5a44abab5471856288696866f400759acaf67671aff9d86420b653d6935e39f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2932eb7d7c3a5653667be03b89cdb922d90dea47a9e2ae38e3dfee26953a7daf"
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
