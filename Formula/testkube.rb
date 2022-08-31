class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.5.6.tar.gz"
  sha256 "a569e32adea6a0c8eb1da67250909a8ef1cf698da379692f9d65652e5281d031"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4251d8c9368dd3d186fb4e8ea30ef5b477abdecd4e732d862244d2cb214f17c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4251d8c9368dd3d186fb4e8ea30ef5b477abdecd4e732d862244d2cb214f17c3"
    sha256 cellar: :any_skip_relocation, monterey:       "77dbdb5b2e952fa97556680890b366e3945d4c882135caa117a1558163ca61b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "77dbdb5b2e952fa97556680890b366e3945d4c882135caa117a1558163ca61b6"
    sha256 cellar: :any_skip_relocation, catalina:       "77dbdb5b2e952fa97556680890b366e3945d4c882135caa117a1558163ca61b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "006a4841300ee4cb2e548b4207546b36def0e56ed39c513850f5345fa6ea5a2e"
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
