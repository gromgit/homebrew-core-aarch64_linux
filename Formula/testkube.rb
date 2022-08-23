class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.34.tar.gz"
  sha256 "a48e7850a9c02e503ce224ba22b83b35db357a08bf3f3cc60413ec35e53cfe9f"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "665655202fde193f717df32b5e8d24a7129bcc952df4dbcf0132294841cb3714"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "665655202fde193f717df32b5e8d24a7129bcc952df4dbcf0132294841cb3714"
    sha256 cellar: :any_skip_relocation, monterey:       "fe05699ea96686ba9fd27f04c7541cfbf7fe0c90347a4d945ca11012d5a20318"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe05699ea96686ba9fd27f04c7541cfbf7fe0c90347a4d945ca11012d5a20318"
    sha256 cellar: :any_skip_relocation, catalina:       "fe05699ea96686ba9fd27f04c7541cfbf7fe0c90347a4d945ca11012d5a20318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaa09e02ebb33dae5b542c787ce1e73c9c449fdfb02ec056511c31fbf8e8a5e7"
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
