class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.14",
      revision: "029be590bfd5003d65ddabb4d4cb8a31bff29c18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51fd508a7f83bc46844166a9440a8ec42ad166acfbd5bad0b29085e3e4ded32d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71cd3da61b50413b99a30ceb744937a19ef300c9f4881e15397ad6dce4d39abf"
    sha256 cellar: :any_skip_relocation, monterey:       "4d4ffc15e0aa22dcd49f86af342c18e43241cea115d95cae3972fc2c0ba63627"
    sha256 cellar: :any_skip_relocation, big_sur:        "859ae1464a0a5ceaf61a3c570868115ab7bfda31f66ea26aeda725a28fc604e4"
    sha256 cellar: :any_skip_relocation, catalina:       "4bdc1b880f2693b3944cc36683926106cfb869392c348079f305be66edc39488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f6f84b2746fdf5599fd5ede0ed528ded634510654491688342bfa69f29bd264"
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
