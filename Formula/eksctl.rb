class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.51.0",
      revision: "5cf431c8754e05e08eef27dcd0864963ccbaf2fd"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b6569134579db096faae0a9891b65f83c4d42fbda4333cc7c4a6ae5e1f8532a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a631a0eb60d52871108585a30027e3fe4dfa240eedb5b7d35484b157903101d2"
    sha256 cellar: :any_skip_relocation, catalina:      "f5b60c1736e7620dc52c8a55b52e7e532c62874ae4fe83de89b7a7011daae82e"
    sha256 cellar: :any_skip_relocation, mojave:        "3047dfb4c07da0ef3f872d9b9134ac1a4fa86453e227ce5ec547fef678a0816f"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    system "make", "build"
    bin.install "eksctl"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "bash")
    (bash_completion/"eksctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
