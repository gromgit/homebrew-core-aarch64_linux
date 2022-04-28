class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.13.tar.gz"
  sha256 "f16a0d5f342378b12d266f0d83e1b76067ca853bac18a63739cdb2f8f62f9aef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fb2d9a1516a9b5d6a513b6bdc5c75ae7d7a0762314f9263b0900cc101778049"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fb2d9a1516a9b5d6a513b6bdc5c75ae7d7a0762314f9263b0900cc101778049"
    sha256 cellar: :any_skip_relocation, monterey:       "5a81d8719aa2492520805ba97cbd08549d9f7f35c30c32dea4b0e912e6cb808a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a81d8719aa2492520805ba97cbd08549d9f7f35c30c32dea4b0e912e6cb808a"
    sha256 cellar: :any_skip_relocation, catalina:       "5a81d8719aa2492520805ba97cbd08549d9f7f35c30c32dea4b0e912e6cb808a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7277cf86abef1a590cd7af6afe2e68cfd2ea0267ff26bc812e320cc33f17cfee"
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
