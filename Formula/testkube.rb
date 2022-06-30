class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.44.tar.gz"
  sha256 "a51e28d3dfe80fc3caaa1a337268ee0e0212dbc19d1f9e607a6475d2abe7dbd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36e521ab0dd315bb7b66a65191fa4b1a47dbea0c2b9c67b28aaaf18e0c68d100"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36e521ab0dd315bb7b66a65191fa4b1a47dbea0c2b9c67b28aaaf18e0c68d100"
    sha256 cellar: :any_skip_relocation, monterey:       "284b1b6e723a1b1c3bb20ad65a5aa9a1f6436f2c919eda479893d1e2fb6cb195"
    sha256 cellar: :any_skip_relocation, big_sur:        "284b1b6e723a1b1c3bb20ad65a5aa9a1f6436f2c919eda479893d1e2fb6cb195"
    sha256 cellar: :any_skip_relocation, catalina:       "284b1b6e723a1b1c3bb20ad65a5aa9a1f6436f2c919eda479893d1e2fb6cb195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e900b7140af6d0cc623f7e374ca7f7a0ad90531cec010b880205aa4f0f2495a7"
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
