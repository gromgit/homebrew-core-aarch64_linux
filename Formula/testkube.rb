class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "4ed9a129451649d618abb9cea69c77af7f4fdab883b7cde95256f82a1a31b024"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1a9f97759290ace31e4d5dc0eff43c4996c95366c13f5bbbdb7fe5b2c4002b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1a9f97759290ace31e4d5dc0eff43c4996c95366c13f5bbbdb7fe5b2c4002b3"
    sha256 cellar: :any_skip_relocation, monterey:       "b848e1076fbab0d301aa1201a5615b65b803e88360014753de3e8bf6f70273e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b848e1076fbab0d301aa1201a5615b65b803e88360014753de3e8bf6f70273e4"
    sha256 cellar: :any_skip_relocation, catalina:       "b848e1076fbab0d301aa1201a5615b65b803e88360014753de3e8bf6f70273e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e5e4e0ded7dbd3d419c42b92079ff401c6ac9ee17e8270eb2bd46d66eee20e4"
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
