class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.11",
      revision: "3d9e9f2f95b7801b90377ecfc4073e5f0f07205b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfb16bd186e36bd835a95f6eadc66dde33283a3ae59776805b4364290ee0bd47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d608714599637ec0f7b0b796dcf2b3ab59addc0012ed4ad9e81204024724d59f"
    sha256 cellar: :any_skip_relocation, monterey:       "3727fb3137e86424d91e4c37df2f6880e3ffd9b1c3eace6c2f96a98427d807d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfcc427053a580f9e91644fc9f9338adc9fd7d535bad943b23978d64bd4d6716"
    sha256 cellar: :any_skip_relocation, catalina:       "51cb01fd0888dcf37074b531493df2a156ffd6d08ee080767060b9d467b93f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7f35d8ee05124d6f353556678da45c0dc8ee8ab49f2c213c7d531a3d88b162d"
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

    generate_completions_from_executable(bin/"argocd", "completion", shells: [:bash, :zsh])
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
