class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.97.0",
      revision: "0ea20abd3da771aa55a9ce15e94859c81c052ae8"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04f129b1c10d836e89399ead438311c3787e3432c2e1c274ce3d0c4c1220b172"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23685600d599bcc170a0e49c24c89ebfddc96f400053c83847ca139d0a4dc816"
    sha256 cellar: :any_skip_relocation, monterey:       "694acd9a2bcabde63beb73ebd0e5f360bc359c4bc7d07412f39c6afb268fad45"
    sha256 cellar: :any_skip_relocation, big_sur:        "427e2f5f6dbe0e631be8057dca422ed0cb4e646e439e3076edec8fc11805b03c"
    sha256 cellar: :any_skip_relocation, catalina:       "349d64addb049053cde43b84ae8c51b7e4116d55c3b8cadcaae3d463ef22375f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96a12e6cb6ed3b7fd54ba548f116d4062478a4a7ed8696ee5af4c843d9909a4b"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  # Eksctl requires newer version of ifacemaker
  #
  # Replace with `depends_on "ifacemaker" => :build` when ifacemaker > 1.2.0
  # Until then get the resource version from go.mod
  resource "ifacemaker" do
    url "https://github.com/vburenin/ifacemaker/archive/b2018d8549dc4d51ce7e2254d6b0a743643613be.tar.gz"
    sha256 "41888bf97133b4e7e190f2040378661b5bcab290d009e1098efbcb9db0f1d82f"
  end

  def install
    resource("ifacemaker").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: buildpath/"ifacemaker")
    end
    inreplace "build/scripts/generate-aws-interfaces.sh", "${GOBIN}/ifacemaker",
                                                          buildpath/"ifacemaker"

    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    system "make", "build"
    bin.install "eksctl"

    bash_output = Utils.safe_popen_read(bin/"eksctl", "completion", "bash")
    (bash_completion/"eksctl").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"eksctl", "completion", "fish")
    (fish_completion/"eksctl.fish").write fish_output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
