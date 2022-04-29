class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.95.0",
      revision: "0c31b223180e5c87cdf109c8d1e7cc0ad9e39a9f"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4f4e7c4387a4ed55301abef8ac2bff02cb9312c3aa2ac72446341aa50a7c53f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb91067869f126325e64b86b96a426648be439efd3588e31adee45083325bd3d"
    sha256 cellar: :any_skip_relocation, monterey:       "65eb074914c4b50b3e028f2c6b9868842278ad65a23f00d47d83887ed9daff61"
    sha256 cellar: :any_skip_relocation, big_sur:        "618db9904500931b61a3fe21f7b8e3fb9e8f8368a33724586a70da0b9a468d0b"
    sha256 cellar: :any_skip_relocation, catalina:       "60c85b7f22d972820297ed1dcbd8f5064aac70540ca20c7d2286c121f3801193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fa9b7ee96016409689fa7acdc2f938511fff305224c473319a873c3b348368d"
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
