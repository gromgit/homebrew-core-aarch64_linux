class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.36.2",
      revision: "76d97c7e9bbcb34240477afcf2152796fdbb779f"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6fd7a8193d1987b7b9d515642035b6bad877a327f88cd15207d85b278e51864" => :big_sur
    sha256 "0d1ead930151f84e70dac405a51409e3369cf8b138fdd0f91bc28ef47f24f85e" => :arm64_big_sur
    sha256 "f440437eec225a4e084d0b3617dbb28582b0bc8121e7a356f56336c3a7ac6bd4" => :catalina
    sha256 "492c73986f81d3610c59840e4df922859763717400927493874a6bfde644284e" => :mojave
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

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "bash")
    (bash_completion/"eksctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
