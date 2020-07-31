class Eksctl < Formula
  desc "The official CLI for Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.25.0",
      revision: "673de795554c4138baeda442268026c2b22c3bd6"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "03d5850e67d21734234cc1f3f941fa4eae5b854c422e4b11b75f4ccc1a5c8c5d" => :catalina
    sha256 "ae9a36b5d032c9a96ee0db0f3d977aaf9164561c5601aa6d0842099be20e1d01" => :mojave
    sha256 "526a06e893de8455abd22ce63556a2866b1ea572bb6e6a33954f3b60cdff52a7" => :high_sierra
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
