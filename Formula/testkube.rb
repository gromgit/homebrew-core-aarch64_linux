class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.5.8.tar.gz"
  sha256 "3b0fc474731dc0935102c0c2d8e022fa7e476f94db8d38d176c35488108b3a45"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0354304ae0ddd2dc677104abb53e4d25f6c59ca3e07dae853f02a5937c008473"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0354304ae0ddd2dc677104abb53e4d25f6c59ca3e07dae853f02a5937c008473"
    sha256 cellar: :any_skip_relocation, monterey:       "8ac2b92bf63d1302bc28a6a0c27496a2c3405d444a79e7529c98a56e720c48ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ac2b92bf63d1302bc28a6a0c27496a2c3405d444a79e7529c98a56e720c48ff"
    sha256 cellar: :any_skip_relocation, catalina:       "8ac2b92bf63d1302bc28a6a0c27496a2c3405d444a79e7529c98a56e720c48ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57a69881938dc9c887055d58d87424b4315b1ff3ac3d4e0cb06a33df538d4289"
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
