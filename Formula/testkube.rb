class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.14.tar.gz"
  sha256 "e6fe014427e16019b881cc33901f2941de21a8d7ec4fdacf7aaac88c65a97835"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1843b28125d1057ad28c0dcf4de6e568105e46754beebf289c5d4d8ab1fbe7a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1843b28125d1057ad28c0dcf4de6e568105e46754beebf289c5d4d8ab1fbe7a4"
    sha256 cellar: :any_skip_relocation, monterey:       "ed7b270d8f1a0aca4b0e2c166f5e1b9ee91f61eacf0f0c1a29fa4995d89ac0f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed7b270d8f1a0aca4b0e2c166f5e1b9ee91f61eacf0f0c1a29fa4995d89ac0f2"
    sha256 cellar: :any_skip_relocation, catalina:       "ed7b270d8f1a0aca4b0e2c166f5e1b9ee91f61eacf0f0c1a29fa4995d89ac0f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60801cf9b807bdf9106723a69d213ee979a4ade6b235bb8e91b697ce0c312daa"
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
