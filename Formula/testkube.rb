class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.30.tar.gz"
  sha256 "61197d23c4e7faf1059ad56ff3baba685a5dbf987755ede5d631baef11099653"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab3a0bdd4e33ceb007467f3564a976b16fde45ff1bc08033263944b8305b7c5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab3a0bdd4e33ceb007467f3564a976b16fde45ff1bc08033263944b8305b7c5f"
    sha256 cellar: :any_skip_relocation, monterey:       "6e66ecaed71d11ad027243299572f2c336cbc3c2c3152e908d7d59b1e7d5d438"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e66ecaed71d11ad027243299572f2c336cbc3c2c3152e908d7d59b1e7d5d438"
    sha256 cellar: :any_skip_relocation, catalina:       "6e66ecaed71d11ad027243299572f2c336cbc3c2c3152e908d7d59b1e7d5d438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8436b42cb96d036eccddb9940534e05ec6fefebdf46b55026beb09a25d3e73ca"
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
