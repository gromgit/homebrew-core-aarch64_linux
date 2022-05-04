class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "4ed9a129451649d618abb9cea69c77af7f4fdab883b7cde95256f82a1a31b024"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4d65d1fe866f3a6d1f2e04afc92d5adf664e665f622dfd296d7b58e9eb02001"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4d65d1fe866f3a6d1f2e04afc92d5adf664e665f622dfd296d7b58e9eb02001"
    sha256 cellar: :any_skip_relocation, monterey:       "477e692eae74e2f584f166e4cdc37b3fadd21503865f30d1a79ce22897fefb3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "477e692eae74e2f584f166e4cdc37b3fadd21503865f30d1a79ce22897fefb3a"
    sha256 cellar: :any_skip_relocation, catalina:       "477e692eae74e2f584f166e4cdc37b3fadd21503865f30d1a79ce22897fefb3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df4eed695ae22bd26d1d2926843060ca9d580a202cedb23eb9dd441c1421edef"
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
