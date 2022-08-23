class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.36.tar.gz"
  sha256 "4e34b284b5906238dc03762da6956ec8663abeffd4ff56471fe85a2525b7e66f"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a1237ad3352edf2d05b5000ac498a71c43d3a849b464baf1a5cb9e1ff406457"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a1237ad3352edf2d05b5000ac498a71c43d3a849b464baf1a5cb9e1ff406457"
    sha256 cellar: :any_skip_relocation, monterey:       "291c61871ab3b3fe31db760ce4865f28f436ffbf5bbaa48894a75aa2e6f775df"
    sha256 cellar: :any_skip_relocation, big_sur:        "291c61871ab3b3fe31db760ce4865f28f436ffbf5bbaa48894a75aa2e6f775df"
    sha256 cellar: :any_skip_relocation, catalina:       "291c61871ab3b3fe31db760ce4865f28f436ffbf5bbaa48894a75aa2e6f775df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "585f03a65bef92fbbbd37050ac9860324e1f17c962dff74acceb44ba2fa2dcaf"
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
