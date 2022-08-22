class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.31.tar.gz"
  sha256 "15a89a3d995ffc047ccb73e3b83bf8468d12f3182f08f11e43a8bb57d4bd7936"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c48e345e253b6b77d784d3d3f45551da5d3a9a68b8ffe4982a11fa183a53946"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c48e345e253b6b77d784d3d3f45551da5d3a9a68b8ffe4982a11fa183a53946"
    sha256 cellar: :any_skip_relocation, monterey:       "2aaaf7b42efc78e90e9e1ddad59f21d8f6c93489c932844e9163a64acdc90581"
    sha256 cellar: :any_skip_relocation, big_sur:        "2aaaf7b42efc78e90e9e1ddad59f21d8f6c93489c932844e9163a64acdc90581"
    sha256 cellar: :any_skip_relocation, catalina:       "2aaaf7b42efc78e90e9e1ddad59f21d8f6c93489c932844e9163a64acdc90581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c4358ffdfff081133c570a4ba26c084010b42502fc8fe34f74b16d329b19129"
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
