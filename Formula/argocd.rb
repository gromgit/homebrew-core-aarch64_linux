class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.6",
      revision: "a48bca03c79b6d63be0c34d6094831bc6916b3bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c3ad04d322bcb3b4ac00716506aa0c40cefcd184fb3011c1f6a0bf527731c29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52827b2675a91bcbb306671767bd597ac4d0cd05c658c79814b1a2ec205a9879"
    sha256 cellar: :any_skip_relocation, monterey:       "99919fa2406b5beed8dabe110c815cc45c87ae419ef9e7aa2b6499ac5aaeb9fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a47f8c26925c22aaa7df1fa839dc0eba4836a356c7dd0f42f581bd19ff5b18d3"
    sha256 cellar: :any_skip_relocation, catalina:       "6948375105af7f89f45cb70fe64e6594072a80e2ea9d51522e44c21306e37b5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7105da8e51d4fe2bc3d61ea51f7c6d99355eb60add85f36a421f68c384e77a99"
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
