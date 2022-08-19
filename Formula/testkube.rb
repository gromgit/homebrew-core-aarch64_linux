class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.28.tar.gz"
  sha256 "a5cd8a3c85f74c8150327c55a49baebba92c72c0f57094ac6b55366ff1ede37b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecb0cc8ceb19648b772759dda7510292a7f892827fd330d171e90c7cd92187fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecb0cc8ceb19648b772759dda7510292a7f892827fd330d171e90c7cd92187fc"
    sha256 cellar: :any_skip_relocation, monterey:       "c1650c9e1d82abb9594b2879727993ecbca8caad920ca50cef322bacfb3ae2ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1650c9e1d82abb9594b2879727993ecbca8caad920ca50cef322bacfb3ae2ba"
    sha256 cellar: :any_skip_relocation, catalina:       "c1650c9e1d82abb9594b2879727993ecbca8caad920ca50cef322bacfb3ae2ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b418f0d1a9a178b24e6dfd30b067a1dea568f16c67b94c9eea6300b26ae86f"
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
