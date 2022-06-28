class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.37.tar.gz"
  sha256 "b40dd90c108d09243090b06a5dc3d22b8f17e52671c1a21114e4ee633b00959d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb29f047b6ea8f959aa33e3965b2a4d062a77deecf4094fbc6690f4728b286fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb29f047b6ea8f959aa33e3965b2a4d062a77deecf4094fbc6690f4728b286fa"
    sha256 cellar: :any_skip_relocation, monterey:       "0ed5c072320eb351c8bf6bcfd78f9ae8141aa5b4580fb10249797db33a979a6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ed5c072320eb351c8bf6bcfd78f9ae8141aa5b4580fb10249797db33a979a6d"
    sha256 cellar: :any_skip_relocation, catalina:       "0ed5c072320eb351c8bf6bcfd78f9ae8141aa5b4580fb10249797db33a979a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "731ff13788642d94be9196c10ab9b147a3e0c057540ae2a74323abf95b7d27c8"
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
