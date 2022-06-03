class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.100.0",
      revision: "b6400b6c60844de35a7e9b173cc76d0debaac438"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac1f612dec591fbb99980b376917a904ad2984ed9c8e4447b552401a548e8140"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e013d8d0b226d8c6ab331288ff1bf070851d242e1bae4d3a57d9849c601232fb"
    sha256 cellar: :any_skip_relocation, monterey:       "29fbc556aa8f6c95ac58692be3d45f9e3c745a57e803093c6a4f636ba335e88a"
    sha256 cellar: :any_skip_relocation, big_sur:        "37b56a902dba823ecab843d0d38ed90f8ecb7f318bb51257de671dee4fa9de2c"
    sha256 cellar: :any_skip_relocation, catalina:       "c5241ad60f8271ddd4699ce4105063f0b1d106ef27aaa9e8472ad6dbdff30248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfd840a5aea5a36e360f244e08a5e3e6b8bf180d201d48421acff8771a503632"
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
