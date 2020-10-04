class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.29.1",
      revision: "a9ca2d8d34bc4e7bd8f611493e5d929ef5844899"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "93a4ffa5a8cc5e7ccc58d61d82b980eb9dbcc15928e125995d8d531ffb533ceb" => :catalina
    sha256 "a38f4b2687a5962b4ab45717689b47f15a8c5634f226349cf4c4e084e240304b" => :mojave
    sha256 "cee2a8841c8ff8ca2ea0708c4029e3a7f14993981eb430b721052f4d1120cd11" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
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

    assert_match "Error: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
