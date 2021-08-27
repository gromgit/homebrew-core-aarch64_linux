class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.63.0",
      revision: "9d97605a75f5f845ff3c4a7a85240d2277eda7fd"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56817f0e6a30a4fef3c54b02ddd26fa853029788c2005de1f1fc48398efc9340"
    sha256 cellar: :any_skip_relocation, big_sur:       "7e23544ec1ee857248b018c4540aa86c9747108ef38385aca6a2e501a6108eaf"
    sha256 cellar: :any_skip_relocation, catalina:      "edbb66a3aa3216748177fefa9f110d7fe17d0b375d1a0f633c2f8b9d891c6449"
    sha256 cellar: :any_skip_relocation, mojave:        "d0e1d56dc8f84358f36a4890a4008864183f9fe4050e7529fb9b916cc11c896d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aca78fccf834968fd410db5116a7bb6513fa9c040c91fcbe10a41e0e0669ec4"
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
