class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.38.tar.gz"
  sha256 "607570ea4fb848db3357bd44ff4dfe494881dfbeabc48a27854f31a13e236150"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcaa55c436c7aefa00b07f739a8d2c635438682b086c37e284d7af8718218d2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcaa55c436c7aefa00b07f739a8d2c635438682b086c37e284d7af8718218d2e"
    sha256 cellar: :any_skip_relocation, monterey:       "1e648d3a7f01c91a494d34c74dc5268da9a5abe0b734383370acdcb024e93950"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e648d3a7f01c91a494d34c74dc5268da9a5abe0b734383370acdcb024e93950"
    sha256 cellar: :any_skip_relocation, catalina:       "1e648d3a7f01c91a494d34c74dc5268da9a5abe0b734383370acdcb024e93950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7d550aaad4b82605a730e09dafaf70015bf1e57506326ac5f4cc7dffa236ba0"
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
