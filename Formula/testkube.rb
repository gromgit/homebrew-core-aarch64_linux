class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "2ed3b9f47b01aa76af9344dba0f525a5e4ba183a07895c8941c7c6d4cba9c516"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "371f0781faf21a244224af7e004a628a7dcb9d327686f7dad89b06851090139f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "371f0781faf21a244224af7e004a628a7dcb9d327686f7dad89b06851090139f"
    sha256 cellar: :any_skip_relocation, monterey:       "f9d9f0ef586a30542a62ae502b230b674914a6f46384ce8f546ecb6e4cedc806"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9d9f0ef586a30542a62ae502b230b674914a6f46384ce8f546ecb6e4cedc806"
    sha256 cellar: :any_skip_relocation, catalina:       "f9d9f0ef586a30542a62ae502b230b674914a6f46384ce8f546ecb6e4cedc806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d03e6d43995b4cc108e3816f3d975bcdade011b4b227d2e2d0c4d0313f058a5"
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
