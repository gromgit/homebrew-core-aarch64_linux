class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.7.tar.gz"
  sha256 "1be7184a5616bfd3fafeeab557cde678be43f53127801babccd70fe2d31c7934"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7a511f842b177f10b5deb27a9069b5d13a84709d20f5edbcc629c5ad709254f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7a511f842b177f10b5deb27a9069b5d13a84709d20f5edbcc629c5ad709254f"
    sha256 cellar: :any_skip_relocation, monterey:       "09f4bd8822bc0af592417f6b0ae4958d876bad9431281ef8bdb686df48180f34"
    sha256 cellar: :any_skip_relocation, big_sur:        "09f4bd8822bc0af592417f6b0ae4958d876bad9431281ef8bdb686df48180f34"
    sha256 cellar: :any_skip_relocation, catalina:       "09f4bd8822bc0af592417f6b0ae4958d876bad9431281ef8bdb686df48180f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14d29ddd7ab02856dd91425d95b88348da4e0a3d08763a68384ffa51710a53f3"
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
