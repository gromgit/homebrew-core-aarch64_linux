class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "fb9b91719141e4412201ba427cab903b1132e4575e87bebe35dc417afb3c635e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0bf797ab452cc880b8f552b9baba35e9c5cf05125c1923ba345a649bc1dff32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0bf797ab452cc880b8f552b9baba35e9c5cf05125c1923ba345a649bc1dff32"
    sha256 cellar: :any_skip_relocation, monterey:       "190737bb883d6a8182ecdbc8b0a2bd1da2a6182cea022bf6bb4ccaa5a9ee0e2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "190737bb883d6a8182ecdbc8b0a2bd1da2a6182cea022bf6bb4ccaa5a9ee0e2d"
    sha256 cellar: :any_skip_relocation, catalina:       "190737bb883d6a8182ecdbc8b0a2bd1da2a6182cea022bf6bb4ccaa5a9ee0e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c4e05b93628b9017563992a2378d14cfd3e1ef1fa1cc6da573ff1e2ca36fbd7"
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
