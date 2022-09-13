class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.5.20.tar.gz"
  sha256 "684b42859b5aab56a17efca8a57beac18cc6b632db184b502fcebd77bca0b7c8"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f5ad779d62d96936990aada7faf4df3d94617e59dd2334b2de77fc7268cbdea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f5ad779d62d96936990aada7faf4df3d94617e59dd2334b2de77fc7268cbdea"
    sha256 cellar: :any_skip_relocation, monterey:       "2a7888e96dbb9b6d82e40c3be2dc2a116f10cf77ac9b70f344ae0efc4a31c151"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a7888e96dbb9b6d82e40c3be2dc2a116f10cf77ac9b70f344ae0efc4a31c151"
    sha256 cellar: :any_skip_relocation, catalina:       "2a7888e96dbb9b6d82e40c3be2dc2a116f10cf77ac9b70f344ae0efc4a31c151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f846cf029a54f7920aaa39357efacabb5c3d9db0c90dac15f7c52cad4b29147"
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
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
