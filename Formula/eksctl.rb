class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.49.0",
      revision: "5ed89559c5e07521f2d1576446844b4cfa36d8e2"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5f6108dd9e3ee267a59acfe862ed395169ebdbe7ee0049c58b6d87846a1d478b"
    sha256 cellar: :any_skip_relocation, big_sur:       "a8fea617f092da8e454d4a4da24e347f9dfbb930a62114b222d0599202e2f3c6"
    sha256 cellar: :any_skip_relocation, catalina:      "dfc7bd73be2f4db29dd0e799c2609651f08bd3167bede170962df09b0f62329d"
    sha256 cellar: :any_skip_relocation, mojave:        "de76cea17d38ed7cba8151617cd5b1f0f31f5eb7f8da7460617ddd3bf9e11ba5"
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
