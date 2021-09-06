class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.65.0",
      revision: "4bc82d3c303a879a0357fe8828d6975246135d24"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "41c5e00302e3f899c2cecb94f3211a7588fe3041b5302cb875dbb0ba40f7de1f"
    sha256 cellar: :any_skip_relocation, big_sur:       "21ad9f3d253c6782901de4a4dbfe3494e96aea46b3f3c268b328c79468606f9a"
    sha256 cellar: :any_skip_relocation, catalina:      "a363509ccf74b4d4d1359811b47fb6a81e501ff9ac93c8987be59c9f81f5879e"
    sha256 cellar: :any_skip_relocation, mojave:        "da4f5db04646fdc521ce5e5fd4cbf25530362a3434a476702eb95229f4bffb94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae0d3c628f6f5e5351d7e0d91675d14c4222cd2464dee4a4006251a01ff96531"
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
