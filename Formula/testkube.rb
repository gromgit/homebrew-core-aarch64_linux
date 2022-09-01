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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8804145734343a5e194518068d22a0ec67d26888d6b583a777476c6c8253dd9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8804145734343a5e194518068d22a0ec67d26888d6b583a777476c6c8253dd9c"
    sha256 cellar: :any_skip_relocation, monterey:       "e7e406af99bde68d50b9088e5697b0757b31097cf935c159eaf21531d6117436"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7e406af99bde68d50b9088e5697b0757b31097cf935c159eaf21531d6117436"
    sha256 cellar: :any_skip_relocation, catalina:       "e7e406af99bde68d50b9088e5697b0757b31097cf935c159eaf21531d6117436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "821ae78426e8f787080ee7907601bb10d433c7aa360fb8ee32e09e378d6c70ed"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

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
