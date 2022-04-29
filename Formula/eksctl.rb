class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.95.0",
      revision: "0c31b223180e5c87cdf109c8d1e7cc0ad9e39a9f"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10cf38d951454c605e07eadad6a815d2877def39d9633a3c0fbffe3fa78ab849"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "122c47bd9ebdc4876659983d6942d416df0b465858ef423a8395f954a29ac24a"
    sha256 cellar: :any_skip_relocation, monterey:       "2c36a17090e4352c893a098854eb1bba08c63dff9a4b31d089af1a3771d120b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "75b7ede327c7d4256b5fc9d1c957afac3a7cbc6574a391e7f3e2457a6497b3c9"
    sha256 cellar: :any_skip_relocation, catalina:       "3cbc32390f269d33772316d24abe17b24de563b3cd054ff39182784233ea9415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a285ef1082be70cdaea99636c26870b49b7586cc60884812399de72ae461ed53"
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
