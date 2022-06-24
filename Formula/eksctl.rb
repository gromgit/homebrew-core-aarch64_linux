class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.104.0",
      revision: "6f5ce91222bd53aad2fd9904c3da87bdacb1105f"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c12318a5b4160a885a870d7353095377a7605802629f44e5b7f09c8d69ac8dc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c55cf80195ef9d651948d0e7cc76a9f2ecb0f215f39b799e61796e98a54b65ab"
    sha256 cellar: :any_skip_relocation, monterey:       "2a47d1edda503ce64a587f441aa99b5a2bf9604b3932416e69127cd06949ac61"
    sha256 cellar: :any_skip_relocation, big_sur:        "28a11fd84c9e22c7fc994f1829010fbac834f94fb0bd241b6f347f9366b7fa5c"
    sha256 cellar: :any_skip_relocation, catalina:       "b8faed11622a164bd8b84205c57ff4d7e30e8617f39962b92ab3d6903c396a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "691b7475887189c4ffdfaacc8eb6551e9d7aa17b03231a205152963499160a97"
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
