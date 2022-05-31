class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "694859b34767c473c9d75b9180a3bbcb25cf6450e9a4a415ca307d3e17e339b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f327f995e26ec557d2050863fd779a5e9020615893828af849a74c0911404a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f327f995e26ec557d2050863fd779a5e9020615893828af849a74c0911404a3"
    sha256 cellar: :any_skip_relocation, monterey:       "c1b8920b0f3a62ac64d35bf38093727abf0498fe3747e3cd87df9efef6e29298"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1b8920b0f3a62ac64d35bf38093727abf0498fe3747e3cd87df9efef6e29298"
    sha256 cellar: :any_skip_relocation, catalina:       "c1b8920b0f3a62ac64d35bf38093727abf0498fe3747e3cd87df9efef6e29298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a025a59133c1816a6868c0914dcef78c5adc0153620b4965b61aae6f974b4822"
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
