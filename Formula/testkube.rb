class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.14.tar.gz"
  sha256 "8d580031fc1328c23492be75f95fd8610d8aa1d73e4d8ac910d562eb3fc55400"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0bfe22f08ae3c883c5b6e893ecf46f60f926b00f5c3c5e5a1745fd62ff5ad82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0bfe22f08ae3c883c5b6e893ecf46f60f926b00f5c3c5e5a1745fd62ff5ad82"
    sha256 cellar: :any_skip_relocation, monterey:       "ab15308bd621d0e2de7d2938684e32a16fb225097fa1856ed5ec73c467fa9e18"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab15308bd621d0e2de7d2938684e32a16fb225097fa1856ed5ec73c467fa9e18"
    sha256 cellar: :any_skip_relocation, catalina:       "ab15308bd621d0e2de7d2938684e32a16fb225097fa1856ed5ec73c467fa9e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecefd39516f05e9d04b6480cb30366e0e2fc555f5acbdecca594c34ce5aadc10"
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
