class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.36.0",
      revision: "2fe9fe4c5a9c8b7f02f70cb919e3f28a17f9d5e3"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f262c0f8c494e1d75043a8be60dfe7e2a7e59c1c426be7124b8c5cf8e5239a08" => :big_sur
    sha256 "751cdaa9a8f4eda668d6d47eca818eafb955cbc245070ce253e8f85b7baf6aa3" => :arm64_big_sur
    sha256 "fb6411c6285512082460428878e486a9cf6a300c5e10c98ff9c54d55e79c616e" => :catalina
    sha256 "b7ff1650ea58534699f35ae713397dbc72954c7672fe3f19fb2c14727ea24656" => :mojave
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
