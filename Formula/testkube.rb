class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "d067a08d4fa57e532836979aa745a843669abbab86280d76293f122ceb267416"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f8007adcfa75f98f248107115580c3cebd6bc2d8291205f525f0737df46dcd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f8007adcfa75f98f248107115580c3cebd6bc2d8291205f525f0737df46dcd3"
    sha256 cellar: :any_skip_relocation, monterey:       "ca60ad95202e7a6ffdf169b91a3792a9df7c1407ac888dc5971bf1292099a480"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca60ad95202e7a6ffdf169b91a3792a9df7c1407ac888dc5971bf1292099a480"
    sha256 cellar: :any_skip_relocation, catalina:       "ca60ad95202e7a6ffdf169b91a3792a9df7c1407ac888dc5971bf1292099a480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96e543ad424d2175f7793bce225c717e0c6f399900241ade579d06a5319b13a6"
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
