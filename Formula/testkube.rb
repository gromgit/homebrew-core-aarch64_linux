class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "952a39fe0310687c275a3ccb35727cd1d6fc3b439845370ffd77cb9e95b7cf5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "469808848060dc94f6c9d8a35d50b9c6a5c9e9fe34298c0e56b59ef430065c87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "469808848060dc94f6c9d8a35d50b9c6a5c9e9fe34298c0e56b59ef430065c87"
    sha256 cellar: :any_skip_relocation, monterey:       "1882feabfd4f241a62a12c3db616516bde5e02e72015483bb3d7cc454acdcce5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1882feabfd4f241a62a12c3db616516bde5e02e72015483bb3d7cc454acdcce5"
    sha256 cellar: :any_skip_relocation, catalina:       "1882feabfd4f241a62a12c3db616516bde5e02e72015483bb3d7cc454acdcce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10ab6266f73a75666e53c9f28607ea44f9424c3063e6d8dce053969585d6b523"
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
