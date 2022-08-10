class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.14.tar.gz"
  sha256 "8d580031fc1328c23492be75f95fd8610d8aa1d73e4d8ac910d562eb3fc55400"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19de5afce672171142c56bda077f621034dd5955d7dbe63103fa1af578f7ec60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19de5afce672171142c56bda077f621034dd5955d7dbe63103fa1af578f7ec60"
    sha256 cellar: :any_skip_relocation, monterey:       "6ed666bdc43b933eee88a3860044cdffd33f543ec2c690e4044e3ad71d904f75"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ed666bdc43b933eee88a3860044cdffd33f543ec2c690e4044e3ad71d904f75"
    sha256 cellar: :any_skip_relocation, catalina:       "6ed666bdc43b933eee88a3860044cdffd33f543ec2c690e4044e3ad71d904f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11dcf69a7b1e470afdd5ccb39714868d2ba447c9351f2e4be51b73722bec47e7"
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
