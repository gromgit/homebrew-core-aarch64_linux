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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4bc0e10d570ef25b49f940bd7aacee480abd52e26f4cf679e9c6407b2cc7bb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4bc0e10d570ef25b49f940bd7aacee480abd52e26f4cf679e9c6407b2cc7bb3"
    sha256 cellar: :any_skip_relocation, monterey:       "a835eefd3a4bde830b63f26d81614e4a7b7245424320b3187134006a54ca3575"
    sha256 cellar: :any_skip_relocation, big_sur:        "a835eefd3a4bde830b63f26d81614e4a7b7245424320b3187134006a54ca3575"
    sha256 cellar: :any_skip_relocation, catalina:       "a835eefd3a4bde830b63f26d81614e4a7b7245424320b3187134006a54ca3575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8154962c2a876647f2891ce868cab94648cdb085ae819dabf59e21b6c95f6995"
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
