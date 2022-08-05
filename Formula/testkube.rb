class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.5.tar.gz"
  sha256 "52814b025245af4f220766eb5f34e2b2face549149e7c6d8aa88d6d3220fa926"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b4ee0a30736ba710606597e646b040284c901540171abbffc18a58d1755ecc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b4ee0a30736ba710606597e646b040284c901540171abbffc18a58d1755ecc3"
    sha256 cellar: :any_skip_relocation, monterey:       "7161183db1626ebe972d61156f86d647828ed401c64b00b8d8b2309e3d289742"
    sha256 cellar: :any_skip_relocation, big_sur:        "7161183db1626ebe972d61156f86d647828ed401c64b00b8d8b2309e3d289742"
    sha256 cellar: :any_skip_relocation, catalina:       "7161183db1626ebe972d61156f86d647828ed401c64b00b8d8b2309e3d289742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5d33f4ed26843d92619f661c902dc49ded3929930737689033439dfa3b4c836"
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
