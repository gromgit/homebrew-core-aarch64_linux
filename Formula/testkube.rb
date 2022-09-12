class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.5.15.tar.gz"
  sha256 "e47a13b64aa596a7b64fe311bb5c3d88cebc9fc7cd616bdc32956244f248c547"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a291a8cf5e8eb1682b3a5adb1ee1ee341fef09f20b3697adc7e1ea23629985ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a291a8cf5e8eb1682b3a5adb1ee1ee341fef09f20b3697adc7e1ea23629985ae"
    sha256 cellar: :any_skip_relocation, monterey:       "b9b9cd7e74f8b8b64d49be469b91fd28a751581fa436df345cf2a91aa04974dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9b9cd7e74f8b8b64d49be469b91fd28a751581fa436df345cf2a91aa04974dd"
    sha256 cellar: :any_skip_relocation, catalina:       "b9b9cd7e74f8b8b64d49be469b91fd28a751581fa436df345cf2a91aa04974dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e70c5f814f3ce8b8d5097d4a283fe97ab94112fcb58315bc35a4fc44550a03ed"
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
