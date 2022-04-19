class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "4c1e9636e0d4e0dbbb793f4d2ffca7fb250d28e1662e8e2623b24655397bf3ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36b1c9f0694ab87670bf95038d3810f23caa350d1cba3b3e05e0fd4a6ca06e9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36b1c9f0694ab87670bf95038d3810f23caa350d1cba3b3e05e0fd4a6ca06e9f"
    sha256 cellar: :any_skip_relocation, monterey:       "64b72a198541cc8ee20e5ac81fec0ee3121efb0a38ccdb0cdb26177fa3538569"
    sha256 cellar: :any_skip_relocation, big_sur:        "64b72a198541cc8ee20e5ac81fec0ee3121efb0a38ccdb0cdb26177fa3538569"
    sha256 cellar: :any_skip_relocation, catalina:       "64b72a198541cc8ee20e5ac81fec0ee3121efb0a38ccdb0cdb26177fa3538569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8904a770b78da53fab8f8aca386a3584e7d88e7475ec61ad48a3284b981d98dd"
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
