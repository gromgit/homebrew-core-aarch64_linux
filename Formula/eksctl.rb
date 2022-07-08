class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.105.0",
      revision: "aa76f1d44bb5cdf78a880a01a296616b9c6e2070"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76477b4f5aaf21b77c6367c794666d006e9d572fb35bdcfcddd3755c0415992d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1df706ae459af22431ccbc8d97e5480b600eaab0491f94137c80fc56439f55a9"
    sha256 cellar: :any_skip_relocation, monterey:       "704d84081d6ecd5c26096a758b19be10252399e0985916bcb1203c9bbc8f1e06"
    sha256 cellar: :any_skip_relocation, big_sur:        "5719700c196d9004f62e34b152a779027004c03b07129c781119e16e198d6305"
    sha256 cellar: :any_skip_relocation, catalina:       "b7a0ce53d7d32589802b5e84b27e8486bc61966285e5d8d94d4d64a66ab796e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29983a627bec171e192421519b5ac9bd0ae8351d608ecaf568a2471b7b6c21d3"
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
