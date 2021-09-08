class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.66.0",
      revision: "2c931c8bc3b0fd74246b282c2cd99a38304b0295"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d0a9adfa4e2bb98ff58446f7c65c9974c2d2453204544305bad0ca574dbe65a"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ec0497bf350351c49eef7623cdbe7f353a18b6532d79a618951cd9f8cd81470"
    sha256 cellar: :any_skip_relocation, catalina:      "e6e302452b6b0a3f321d20c19569a4de2752a6bfffd260cc907941ecb78cd51e"
    sha256 cellar: :any_skip_relocation, mojave:        "325d95237dfebfa27482ae111bccb35620ee401884626255494886e9e9cff14e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "922c36d6218bbf9ba638b9291d978a2f60f9c9a44759b5aed0e2e6c606f7d0ee"
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

    bash_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "bash")
    (bash_completion/"eksctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "fish")
    (zsh_completion/"eksctl.fish").write fish_output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
