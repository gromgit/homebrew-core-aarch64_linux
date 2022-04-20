class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "22f8411fa6cd0a96ce2fde87705ab08c77bdf64f74069885d8e9bf0c4483beec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "330c8952b90e47674ac78472f2ff7f7f40c422363c834098d24bea88e3c97821"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "330c8952b90e47674ac78472f2ff7f7f40c422363c834098d24bea88e3c97821"
    sha256 cellar: :any_skip_relocation, monterey:       "e350a0af007d8edd14c3bb36448648043f13d598f72c453aabfe57786c96a91b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e350a0af007d8edd14c3bb36448648043f13d598f72c453aabfe57786c96a91b"
    sha256 cellar: :any_skip_relocation, catalina:       "e350a0af007d8edd14c3bb36448648043f13d598f72c453aabfe57786c96a91b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4f58d36c414fa762edf07a1adf92ffc9f811cb8d828b623c6b68241b3809ea4"
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
