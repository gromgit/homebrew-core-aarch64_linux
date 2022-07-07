class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "fb9b91719141e4412201ba427cab903b1132e4575e87bebe35dc417afb3c635e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a1fab12d08572c2ca83c45f186dcc37c52020d2fdd096541cf19d3861660292"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a1fab12d08572c2ca83c45f186dcc37c52020d2fdd096541cf19d3861660292"
    sha256 cellar: :any_skip_relocation, monterey:       "09b8261b1f5be4fd2fe4f5cb71653d10e4d5bcacfe415c1d9c065f05bfc2ae5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "09b8261b1f5be4fd2fe4f5cb71653d10e4d5bcacfe415c1d9c065f05bfc2ae5d"
    sha256 cellar: :any_skip_relocation, catalina:       "09b8261b1f5be4fd2fe4f5cb71653d10e4d5bcacfe415c1d9c065f05bfc2ae5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc4a491e588b76a08245dae373c75a5b07367e845744ad8fb318dd89876f1c53"
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
