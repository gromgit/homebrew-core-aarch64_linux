class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "dd0f2e27f836f2baab8ee0ddaa107d411eb6a9b3dfeeb8182934dc4cd99493dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5472c21536cc96b8c604d8206ce2cf6fd8ab4d9a7a4c89b06188edad2ccee81e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5472c21536cc96b8c604d8206ce2cf6fd8ab4d9a7a4c89b06188edad2ccee81e"
    sha256 cellar: :any_skip_relocation, monterey:       "7aab954a2f73385966b0c785c28b3d82044b66ec02e7e51f1ad0da99568f0e9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7aab954a2f73385966b0c785c28b3d82044b66ec02e7e51f1ad0da99568f0e9f"
    sha256 cellar: :any_skip_relocation, catalina:       "7aab954a2f73385966b0c785c28b3d82044b66ec02e7e51f1ad0da99568f0e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "850787cc6f8108252c515e535473bee53fc90eb12f6649f2aa8d3e3fd5f40714"
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
