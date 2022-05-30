class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "7cec0d48df8a4b92ae5569e82504472764785aaaffd96fcee94e7eb7c6300553"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b782bdcad93feb8967436241ba0ae711225f6dec189fce7b487b8736749f26e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b782bdcad93feb8967436241ba0ae711225f6dec189fce7b487b8736749f26e"
    sha256 cellar: :any_skip_relocation, monterey:       "d4e9c07f2bab9816ae0aa0a8b904eaa1d8c5881a69588b25fa2187b0cc56b6fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4e9c07f2bab9816ae0aa0a8b904eaa1d8c5881a69588b25fa2187b0cc56b6fb"
    sha256 cellar: :any_skip_relocation, catalina:       "d4e9c07f2bab9816ae0aa0a8b904eaa1d8c5881a69588b25fa2187b0cc56b6fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41b797eca742647a7a9689e78014b6ec416a6110e29d49aea373e2ceeb800a99"
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
