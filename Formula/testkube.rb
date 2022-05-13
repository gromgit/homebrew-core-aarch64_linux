class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "632c9a694198facf77bb0536a0317defa81bd3c3bd2c69a656c0d030da22d4d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78262523b7aaffe3b9671ac33185bda6f2f6ebf6bd664b2da120755d704451ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78262523b7aaffe3b9671ac33185bda6f2f6ebf6bd664b2da120755d704451ca"
    sha256 cellar: :any_skip_relocation, monterey:       "a7e2f8092c41912ccd90fc781bf54cb5683a8b2e1592d5a0822d64213fcd6f6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7e2f8092c41912ccd90fc781bf54cb5683a8b2e1592d5a0822d64213fcd6f6e"
    sha256 cellar: :any_skip_relocation, catalina:       "a7e2f8092c41912ccd90fc781bf54cb5683a8b2e1592d5a0822d64213fcd6f6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f78b78f278388a24fe1db81ce573c94891652c523a7ec3519a51e71a180ea6b3"
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
