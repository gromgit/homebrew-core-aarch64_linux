class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "dd0f2e27f836f2baab8ee0ddaa107d411eb6a9b3dfeeb8182934dc4cd99493dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e729f363e6db45117094b72945318ea3456b52b124c50e4ca9e5f349a4061b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e729f363e6db45117094b72945318ea3456b52b124c50e4ca9e5f349a4061b9"
    sha256 cellar: :any_skip_relocation, monterey:       "8cf4e78169079586f4df036865ec138e8b541126319b93d5d32adf2c8c815ec1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cf4e78169079586f4df036865ec138e8b541126319b93d5d32adf2c8c815ec1"
    sha256 cellar: :any_skip_relocation, catalina:       "8cf4e78169079586f4df036865ec138e8b541126319b93d5d32adf2c8c815ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40059e1486e02fe9154c6d3d7e46347de30764aa0fdf02ed59b891630a3b793c"
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
