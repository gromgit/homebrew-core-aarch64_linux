class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.9.tar.gz"
  sha256 "ed89a8b168f66d9c894df6bf9e369f3f9d3c67742443a204ec54bd5070f4355e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfe8b6c6bb71ed79529e41e659645dcaf8b7771a629f7d321b5934357a8570ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfe8b6c6bb71ed79529e41e659645dcaf8b7771a629f7d321b5934357a8570ec"
    sha256 cellar: :any_skip_relocation, monterey:       "ddcc0ea2f8e1f5adcd5cac814c38d3ac9c28a768b1e9c305d066a518197b3d50"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddcc0ea2f8e1f5adcd5cac814c38d3ac9c28a768b1e9c305d066a518197b3d50"
    sha256 cellar: :any_skip_relocation, catalina:       "ddcc0ea2f8e1f5adcd5cac814c38d3ac9c28a768b1e9c305d066a518197b3d50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf0fd19a19725cd73ba5ad9f965799abafeff02dbbb2f16984179a6cf70b56d3"
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
