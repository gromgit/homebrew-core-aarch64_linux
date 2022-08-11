class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.20.tar.gz"
  sha256 "5c91b7868519383caba095cef3fbb7cb346d8343989009a85e2683063b459eb2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b934ff7c141b83460003c18f9e57270e38de97b4c3dc6698da13ee2e16b64de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b934ff7c141b83460003c18f9e57270e38de97b4c3dc6698da13ee2e16b64de"
    sha256 cellar: :any_skip_relocation, monterey:       "2686c008c2f940536e01b32b0c5699320381c8c9dce8274d7da140b38daf6251"
    sha256 cellar: :any_skip_relocation, big_sur:        "2686c008c2f940536e01b32b0c5699320381c8c9dce8274d7da140b38daf6251"
    sha256 cellar: :any_skip_relocation, catalina:       "2686c008c2f940536e01b32b0c5699320381c8c9dce8274d7da140b38daf6251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efa04c2026250ed211b8ed03c324047a27d3feefaafb675ce968969802e1eb99"
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
