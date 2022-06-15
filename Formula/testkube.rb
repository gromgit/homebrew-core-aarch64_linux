class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.19.tar.gz"
  sha256 "224eec45707edb19552c7d810439a1b153020236e771ba0651cfa0f139758386"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee8110ab8b8a6ad00501108c765c33f788ece6418ce9a0402ac19114fa0a4132"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee8110ab8b8a6ad00501108c765c33f788ece6418ce9a0402ac19114fa0a4132"
    sha256 cellar: :any_skip_relocation, monterey:       "84de52bc624b2855e6293516e40fe7bff2e06489138ac814b678ecb4dc97c3d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "84de52bc624b2855e6293516e40fe7bff2e06489138ac814b678ecb4dc97c3d3"
    sha256 cellar: :any_skip_relocation, catalina:       "84de52bc624b2855e6293516e40fe7bff2e06489138ac814b678ecb4dc97c3d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aec21b40a459b0d1ccdfc3e363c9979e07561c6544c4124136bcb31bbf750f0c"
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
