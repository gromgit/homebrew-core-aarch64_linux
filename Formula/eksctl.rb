class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.107.0",
      revision: "b204c3ce61a2fa388a7930963d48ca880b009b38"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "221372698078dd30861777a36c7ffb1584c26311aabfb34641e4036ae6c7b5a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ccda785d7d5ceb6e19714c03c50e922a1c9550eea454fee9dc799774386154a"
    sha256 cellar: :any_skip_relocation, monterey:       "ddbc921e9c28afa7d1036172baa34cf36a31ff83638ca7d1eea9cfe14837a7ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "936b3385b1f438b2d65718a39faf4b7a20f14b3c9f900592ec087032b339c50f"
    sha256 cellar: :any_skip_relocation, catalina:       "13359bc3446d93fd3fb17b2a4baf44ee741a3048a7f64475a6294a3fa380f91b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb1b45cb2fcf3b5df6e88e831e0898ff90f9a6042c8406b6454f99d15ef51069"
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
