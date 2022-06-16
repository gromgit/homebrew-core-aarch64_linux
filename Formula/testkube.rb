class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.21.tar.gz"
  sha256 "74b26e708f6203a9c57834138433c22e728dc3e323d7ac225ca4d72f13e08ad0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00535ba1942db7f2be6e4e05fa09b24407dad033e605e194e5bc0684c21345d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00535ba1942db7f2be6e4e05fa09b24407dad033e605e194e5bc0684c21345d0"
    sha256 cellar: :any_skip_relocation, monterey:       "d78c834f417d818bb8f5d4a8187dcad0c0e0ab04786fd451408e9a6fbca6c593"
    sha256 cellar: :any_skip_relocation, big_sur:        "d78c834f417d818bb8f5d4a8187dcad0c0e0ab04786fd451408e9a6fbca6c593"
    sha256 cellar: :any_skip_relocation, catalina:       "d78c834f417d818bb8f5d4a8187dcad0c0e0ab04786fd451408e9a6fbca6c593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69457e3928fe0f7cafc7770d45af24c90202151701588b338d72272f71be39a9"
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
