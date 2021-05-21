class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.51.0",
      revision: "5cf431c8754e05e08eef27dcd0864963ccbaf2fd"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f7f1efb868ce5964bbd4533fc07be5e0b20d5a9c7079c210f34f85dff8524988"
    sha256 cellar: :any_skip_relocation, big_sur:       "afd6fc312512496ac9576d8e54dd4c7bc11c4bc6702f3d02717be314aa8cc292"
    sha256 cellar: :any_skip_relocation, catalina:      "05fb48756a90b7bb568ffed40b921cd59791e7bee4e1c252cde30a7146cc92c4"
    sha256 cellar: :any_skip_relocation, mojave:        "da015cbf6416c1eb8cb70acbbeff5c7f0b844c411003972a98b5e35d89480bc2"
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
