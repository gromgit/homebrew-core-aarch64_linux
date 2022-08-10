class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.18.tar.gz"
  sha256 "fe73513e2bb30a99a15fd82f5d965a2a16d9b781a67d4d18784c30045842681d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58ab497ba5128dcacfc82b71ccffbcb9bf9fd871fd96fcd12cd577f6fc0b3b47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58ab497ba5128dcacfc82b71ccffbcb9bf9fd871fd96fcd12cd577f6fc0b3b47"
    sha256 cellar: :any_skip_relocation, monterey:       "48f34f01d4656445907b3dc49e71309c7f0dfa735bb35d98c546188f9215c10f"
    sha256 cellar: :any_skip_relocation, big_sur:        "48f34f01d4656445907b3dc49e71309c7f0dfa735bb35d98c546188f9215c10f"
    sha256 cellar: :any_skip_relocation, catalina:       "48f34f01d4656445907b3dc49e71309c7f0dfa735bb35d98c546188f9215c10f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfae6e800383ca12fcecc899bd8559e13c62ae2e5ad802212e9c99bd519e1777"
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
