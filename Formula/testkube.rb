class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.24.tar.gz"
  sha256 "d831e555a10f1f352f4a62607094bb0a8048224db52e4bd47dd59f7ea05bc0b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acd07a2282dc9f9abb0b2039597517c723a521f93b4a8a2e38a6d5ff7fa2cf05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acd07a2282dc9f9abb0b2039597517c723a521f93b4a8a2e38a6d5ff7fa2cf05"
    sha256 cellar: :any_skip_relocation, monterey:       "910ce4430a2c10b668d2aa85006c3e2af18b6fec55e6bedf1011e79bc254d696"
    sha256 cellar: :any_skip_relocation, big_sur:        "910ce4430a2c10b668d2aa85006c3e2af18b6fec55e6bedf1011e79bc254d696"
    sha256 cellar: :any_skip_relocation, catalina:       "910ce4430a2c10b668d2aa85006c3e2af18b6fec55e6bedf1011e79bc254d696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a34934e0ee28663a9274714162f64899d98ead626219221a20f680e64421f96"
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
