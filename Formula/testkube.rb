class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.28.tar.gz"
  sha256 "a0c72f9f9316e74efc574a286365827ee7de3923db647fe9b3c0bb8de398d046"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "926843d5b702a1281d3b5991411fbc85009e5fc9e36220bef7da6faa95faf5e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "926843d5b702a1281d3b5991411fbc85009e5fc9e36220bef7da6faa95faf5e7"
    sha256 cellar: :any_skip_relocation, monterey:       "0af3ef17e0ed556a2b6afd0ad4820c747ad68558b9ffb370e2eaed2feb687142"
    sha256 cellar: :any_skip_relocation, big_sur:        "0af3ef17e0ed556a2b6afd0ad4820c747ad68558b9ffb370e2eaed2feb687142"
    sha256 cellar: :any_skip_relocation, catalina:       "0af3ef17e0ed556a2b6afd0ad4820c747ad68558b9ffb370e2eaed2feb687142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2738b96011fab2111a8b778cc2ba912b305446c119c0056bc06b886f4ab9d98"
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
