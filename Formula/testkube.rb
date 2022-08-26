class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.5.2.tar.gz"
  sha256 "308e47e835cbd63a301070087ed4eef151cc86f22066825505fc27d1cba85fdc"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "089f7c650e9baa91b3d71e564f2812c22a87f73abc8de2b674cb66d99475e3d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "089f7c650e9baa91b3d71e564f2812c22a87f73abc8de2b674cb66d99475e3d2"
    sha256 cellar: :any_skip_relocation, monterey:       "db8401b7fd6f49e5a3927c2fc3c8c41fef3d86a88b3078d5f45e510cc5382097"
    sha256 cellar: :any_skip_relocation, big_sur:        "db8401b7fd6f49e5a3927c2fc3c8c41fef3d86a88b3078d5f45e510cc5382097"
    sha256 cellar: :any_skip_relocation, catalina:       "db8401b7fd6f49e5a3927c2fc3c8c41fef3d86a88b3078d5f45e510cc5382097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6f8397139818acf229cd460b88fff6ee9c672f95898e8542ebd2a1b56c58b4a"
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
