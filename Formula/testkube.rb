class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.20.tar.gz"
  sha256 "5c91b7868519383caba095cef3fbb7cb346d8343989009a85e2683063b459eb2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89f9efbea901f583946af9dd4f1ed0a2dd9cbc4ebc683057bd7cb2ff9e8fc107"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89f9efbea901f583946af9dd4f1ed0a2dd9cbc4ebc683057bd7cb2ff9e8fc107"
    sha256 cellar: :any_skip_relocation, monterey:       "0d3d62293ea4788770d0fceb30ee27406b61e372215e98f3df111e36bd48dd4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d3d62293ea4788770d0fceb30ee27406b61e372215e98f3df111e36bd48dd4b"
    sha256 cellar: :any_skip_relocation, catalina:       "0d3d62293ea4788770d0fceb30ee27406b61e372215e98f3df111e36bd48dd4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20355a65b433c17878feb62ead5fef03386f5e358f97765103eb10e689be98ab"
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
