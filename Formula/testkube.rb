class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.6.0.tar.gz"
  sha256 "38bbf31f7f3d693799c6b435bb78e16260e46a77ac5b45dfc08d86ef8ac52025"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfe708bca12db8d14c76f1b8f84503e7f745c214ec25411c6000fb26ebf3d6be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfe708bca12db8d14c76f1b8f84503e7f745c214ec25411c6000fb26ebf3d6be"
    sha256 cellar: :any_skip_relocation, monterey:       "8c70e4b583af12b8d872e4a0ff3e85c414f8c16775a5936f187a2851d86e1a75"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c70e4b583af12b8d872e4a0ff3e85c414f8c16775a5936f187a2851d86e1a75"
    sha256 cellar: :any_skip_relocation, catalina:       "8c70e4b583af12b8d872e4a0ff3e85c414f8c16775a5936f187a2851d86e1a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3442a034bd91907cdf3c27e55192db61aa16cf3af915c96a7f73fb1db5e681c8"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
