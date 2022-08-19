class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.29.tar.gz"
  sha256 "9a924d623422830f1b1b2c92bba4222e19b3c32a0d4c5a98792b301e9de3a689"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e43a9a364c9d2ac4fd1875d303f501ec2e446bd0a3735ab102fc37075c405e0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e43a9a364c9d2ac4fd1875d303f501ec2e446bd0a3735ab102fc37075c405e0c"
    sha256 cellar: :any_skip_relocation, monterey:       "5912c4c75b01d4c58b91ae1113618fcce94fe58dfbad0f2245b9b2d557d1f0dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5912c4c75b01d4c58b91ae1113618fcce94fe58dfbad0f2245b9b2d557d1f0dc"
    sha256 cellar: :any_skip_relocation, catalina:       "5912c4c75b01d4c58b91ae1113618fcce94fe58dfbad0f2245b9b2d557d1f0dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5dc4896122914b81a18d10ce5aaf7cea709d115d0c9957f7df7e354811ed457"
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
