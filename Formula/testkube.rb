class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.27.tar.gz"
  sha256 "2f76e2de642a43f2b0ef0941b0e7b7643f67ab666810aac03bbca6b4cf390f0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6e00ac99f940771da9adfce6af2896547a870ac1cdd3e0377727d85ee1880ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6e00ac99f940771da9adfce6af2896547a870ac1cdd3e0377727d85ee1880ef"
    sha256 cellar: :any_skip_relocation, monterey:       "0072e65b06d7f8727dbe62e09ee16d564041e00f9abccff3f9bd5fad9daed003"
    sha256 cellar: :any_skip_relocation, big_sur:        "0072e65b06d7f8727dbe62e09ee16d564041e00f9abccff3f9bd5fad9daed003"
    sha256 cellar: :any_skip_relocation, catalina:       "0072e65b06d7f8727dbe62e09ee16d564041e00f9abccff3f9bd5fad9daed003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e971e1caa1f344e15d0c14ed3d56a3fd33ba82b65c61c78113f636957523de9"
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
