class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.35.tar.gz"
  sha256 "2acf6eee72f1cd097b085e9cdc2b4ffdb5411aac0e488282fe3e29340a9cff07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d94ee7fba3abb1bb256408eb46b5b68fc399ed66beb9388cd37dc040dd901b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d94ee7fba3abb1bb256408eb46b5b68fc399ed66beb9388cd37dc040dd901b4"
    sha256 cellar: :any_skip_relocation, monterey:       "8e461e5e941e9efeddcbc480cdfe7c2e7cd3823e7939e1e7a604d5b1aae48ac2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e461e5e941e9efeddcbc480cdfe7c2e7cd3823e7939e1e7a604d5b1aae48ac2"
    sha256 cellar: :any_skip_relocation, catalina:       "8e461e5e941e9efeddcbc480cdfe7c2e7cd3823e7939e1e7a604d5b1aae48ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "614eec3cd6f7a73e3bced687998f517fcca5d972c54eb7971ca34a68a47966d0"
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
