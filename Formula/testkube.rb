class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "2a8c9b7b6f4e088e82bac8dcc3b80fb4033dd02336a8e700ef9095d1c7d12672"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "422e41c087c5ced0915a15646ddd104868842c070f47ef05d51a2baf00946721"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "422e41c087c5ced0915a15646ddd104868842c070f47ef05d51a2baf00946721"
    sha256 cellar: :any_skip_relocation, monterey:       "da6f9db4c97a0962561b8e74dcc06b21c8e1ad16f0a7fe6bff862ed60ee6a0e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "da6f9db4c97a0962561b8e74dcc06b21c8e1ad16f0a7fe6bff862ed60ee6a0e1"
    sha256 cellar: :any_skip_relocation, catalina:       "da6f9db4c97a0962561b8e74dcc06b21c8e1ad16f0a7fe6bff862ed60ee6a0e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7129a0d5b0e8ecf209a348fa50aa3023eb6a7cfa8358ecd2adfd2b4aafa4f4f8"
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
