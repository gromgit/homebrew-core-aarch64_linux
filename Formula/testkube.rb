class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.9.tar.gz"
  sha256 "ed89a8b168f66d9c894df6bf9e369f3f9d3c67742443a204ec54bd5070f4355e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0c5e39067c4fb537ed46f721d6d160b3caafb977b5c227982e0f309ac20afe8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0c5e39067c4fb537ed46f721d6d160b3caafb977b5c227982e0f309ac20afe8"
    sha256 cellar: :any_skip_relocation, monterey:       "89186fe1bebab47208ae1f1aa9a5d7f7f06624e7b5f9f60a17e1a14e5ae318a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "89186fe1bebab47208ae1f1aa9a5d7f7f06624e7b5f9f60a17e1a14e5ae318a9"
    sha256 cellar: :any_skip_relocation, catalina:       "89186fe1bebab47208ae1f1aa9a5d7f7f06624e7b5f9f60a17e1a14e5ae318a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "346338340215bef02d701b2be0f3f3789078c6d6c8bc7858b810a0ded1d0bb9d"
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
