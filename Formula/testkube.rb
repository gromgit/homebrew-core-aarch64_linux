class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.43.tar.gz"
  sha256 "1689faaacec78f45c018318f41f4bce6968802e42171895880ff55c4120ea183"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72bb0a635a1a38b9ff1d29714123b52005399252f878281b52cc12c1348446e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72bb0a635a1a38b9ff1d29714123b52005399252f878281b52cc12c1348446e8"
    sha256 cellar: :any_skip_relocation, monterey:       "9a9de4e11d623a9501f15b561afc53a7772404e2f9f8caad9de82aadf4e16bc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a9de4e11d623a9501f15b561afc53a7772404e2f9f8caad9de82aadf4e16bc5"
    sha256 cellar: :any_skip_relocation, catalina:       "9a9de4e11d623a9501f15b561afc53a7772404e2f9f8caad9de82aadf4e16bc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e8036365f7d3312fdfe440987ab89cb1b4d534dd7dcd4c70add5703a1fc709d"
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
