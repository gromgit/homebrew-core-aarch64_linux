class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.44.tar.gz"
  sha256 "a51e28d3dfe80fc3caaa1a337268ee0e0212dbc19d1f9e607a6475d2abe7dbd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b57e21e6f6ccb0116e7376a08fafd3eef525b0954235fb3418a02845056c2df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b57e21e6f6ccb0116e7376a08fafd3eef525b0954235fb3418a02845056c2df"
    sha256 cellar: :any_skip_relocation, monterey:       "0f94c03f38a609824e73c4efc8ae1c9ec494d75a0679d3021b733bcc643871ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f94c03f38a609824e73c4efc8ae1c9ec494d75a0679d3021b733bcc643871ce"
    sha256 cellar: :any_skip_relocation, catalina:       "0f94c03f38a609824e73c4efc8ae1c9ec494d75a0679d3021b733bcc643871ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b86f1fe328d50fa13a40155277bc4c97b925bed2b95640c32091a82e0f13ad4a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
