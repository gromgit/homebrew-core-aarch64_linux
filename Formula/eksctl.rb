class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.110.0",
      revision: "b6664f85290fedfd5926d091f3374f16633f5c36"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1499f80ab2c5e4fd573e46c386997a2fce514222067f4820c2221df870d37c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aeb42c85187a0d3e9cf895df14d57d2866426d7d71c3913bcfb88ed34c6a4a58"
    sha256 cellar: :any_skip_relocation, monterey:       "8648c987e98fbd5a51ae64edbd161d1e5937f6bf5775b65254b0d7cafd5745d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2643d8a170e076fc3ac91a1806a677abedac3dda0441d07e97505dd4732deb42"
    sha256 cellar: :any_skip_relocation, catalina:       "8621af38fb3ddebfe6a3c07c733caddfd5fa25760faf07d14a16a0b026127f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9266378714d04eb4934e3730329a82a9825c04f88f79bce68dc19587b524f499"
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
