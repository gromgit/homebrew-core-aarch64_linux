class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.3.54.tar.gz"
  sha256 "0f222dbddccf9212a4372ac3beabff12310649e1b9ea6703b43fa1dabc9a5f60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8b9e7da0e08012129b2f7a231cdc6fb47cf20400fa4a0f7fe955142f004ea85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8b9e7da0e08012129b2f7a231cdc6fb47cf20400fa4a0f7fe955142f004ea85"
    sha256 cellar: :any_skip_relocation, monterey:       "e3320bee6eb3300f2983dd3baef1677b6d85cef7ae04fdafe941c4f0d9f29663"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3320bee6eb3300f2983dd3baef1677b6d85cef7ae04fdafe941c4f0d9f29663"
    sha256 cellar: :any_skip_relocation, catalina:       "e3320bee6eb3300f2983dd3baef1677b6d85cef7ae04fdafe941c4f0d9f29663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5701ad77e1af26d2158b37d84f58c84c59a0522dc0076c04d5264b406ef97b70"
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
