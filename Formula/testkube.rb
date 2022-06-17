class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.26.tar.gz"
  sha256 "bd52d7fd40bcaab3b5a9e667d072b7d0ba3d93177bee3e41c3a48941790b23ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c28cccd919113c79d80aac02da93ada1f72acfee9a8cb888d6f30c631f408ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c28cccd919113c79d80aac02da93ada1f72acfee9a8cb888d6f30c631f408ad"
    sha256 cellar: :any_skip_relocation, monterey:       "0a87d94048b1ed39a465956387eb4c618666d9f579a50cfb6582e71e13cda7b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a87d94048b1ed39a465956387eb4c618666d9f579a50cfb6582e71e13cda7b5"
    sha256 cellar: :any_skip_relocation, catalina:       "0a87d94048b1ed39a465956387eb4c618666d9f579a50cfb6582e71e13cda7b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff0cd3951567141179d47ded1eddfda0366a689b50493b0ab2f0c401bf37fb41"
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
