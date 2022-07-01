class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.47.tar.gz"
  sha256 "e00518a89cce99c2b9b253c5c29747ee88189ccc9972ba375216485d5219a605"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "559a31cf3a089e6e26cbf49139c2fd2475c0855c1f86618323ef2efb505f6c04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "559a31cf3a089e6e26cbf49139c2fd2475c0855c1f86618323ef2efb505f6c04"
    sha256 cellar: :any_skip_relocation, monterey:       "a3abbbc0c1644af9a0d473b68870b431eb870bdfce4a46bd2279b7bec647bbdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3abbbc0c1644af9a0d473b68870b431eb870bdfce4a46bd2279b7bec647bbdb"
    sha256 cellar: :any_skip_relocation, catalina:       "a3abbbc0c1644af9a0d473b68870b431eb870bdfce4a46bd2279b7bec647bbdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "395b18f16082a7f17c493d6748578e9db051b2ada0238ded660a286a686c7cca"
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
