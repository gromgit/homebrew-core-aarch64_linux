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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b3733887a585045321dbf58c20d44009112d391e0d535a4eab5a7a004ad1ee4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b3733887a585045321dbf58c20d44009112d391e0d535a4eab5a7a004ad1ee4"
    sha256 cellar: :any_skip_relocation, monterey:       "c43b008b2cfdb328ace8734e3cc325eb8400f59eb57af7951ce4ec451b3b236e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c43b008b2cfdb328ace8734e3cc325eb8400f59eb57af7951ce4ec451b3b236e"
    sha256 cellar: :any_skip_relocation, catalina:       "c43b008b2cfdb328ace8734e3cc325eb8400f59eb57af7951ce4ec451b3b236e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a268e1d943d237c8f448fd7ae08a9c424303e9da92e3b9a00960793d1944783"
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
