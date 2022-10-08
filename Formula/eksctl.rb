class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.113.0",
      revision: "e493c31d408ab66bd434efef9aa4da9e1ce90847"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1bc10f01c3a5395d6307f7e6c2e8c7ec07c06b56c755e43b8185944f8116ca8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0331f1b5d910edd92d6634cfe853780757cf3258613ee2451f0e567c726e75d"
    sha256 cellar: :any_skip_relocation, monterey:       "57e52c4752ba4d000f0a5ec6fe97cbac401e027b02e8971a416d8980dba47e2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "77b432603bddaa7be8a9a68639e7a65a369d55a406d3afde1bcb5b19c5e1194a"
    sha256 cellar: :any_skip_relocation, catalina:       "561330afdf2f2c09abac8969405cec4a5dc2959cf6e498dcb341a477796452fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "accb1d8857e2262c7dd8b49517e4290ee9f4526325fbe6de82414c3bb9173bfd"
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
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
