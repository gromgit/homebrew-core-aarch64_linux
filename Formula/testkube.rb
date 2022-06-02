class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "401e660aac9474cf1a9098aeb4a333a876d9afaa0c3c8cbf498586b208e7db80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08f188e7a2bbaa4a8127444305bc9e4d7dc8a0d4cfeb695bf25bc8eae8386028"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08f188e7a2bbaa4a8127444305bc9e4d7dc8a0d4cfeb695bf25bc8eae8386028"
    sha256 cellar: :any_skip_relocation, monterey:       "f8d083915adb12715d58861712e9f3592e4a1c8456a9c0e76a5ab7d8fa8f68a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8d083915adb12715d58861712e9f3592e4a1c8456a9c0e76a5ab7d8fa8f68a1"
    sha256 cellar: :any_skip_relocation, catalina:       "f8d083915adb12715d58861712e9f3592e4a1c8456a9c0e76a5ab7d8fa8f68a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e063b70097079af4759d6d967177e317e1783ca8f3793bd4117c78c3afdeddeb"
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
