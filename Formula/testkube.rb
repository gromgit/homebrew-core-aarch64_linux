class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "c69cf5ac0ef2244182c6710eb692db436265cc8f7c1aa59bbad6f1c375d1921d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d634e1106de6c9189230ae57dddbd996193fc2f89d07c813c715fd114c1c60c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d634e1106de6c9189230ae57dddbd996193fc2f89d07c813c715fd114c1c60c7"
    sha256 cellar: :any_skip_relocation, monterey:       "9c999e0d9292266290375132487dce214568c780518504ec461a8d0ed9068e80"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c999e0d9292266290375132487dce214568c780518504ec461a8d0ed9068e80"
    sha256 cellar: :any_skip_relocation, catalina:       "9c999e0d9292266290375132487dce214568c780518504ec461a8d0ed9068e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02cc2f594710a31091f52553fd3438a156a63e7aa5c6f8a36bdc99f709b8f37e"
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
