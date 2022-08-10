class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.15.tar.gz"
  sha256 "a3b0bcd8a8d781090944f40204d0d5b30f910b2d650a4270a749f0eca1b07bfa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f310f0378270e9305a1d9a52d9e3daf0fae08478d658f7cd1909dc2e9c63fd29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f310f0378270e9305a1d9a52d9e3daf0fae08478d658f7cd1909dc2e9c63fd29"
    sha256 cellar: :any_skip_relocation, monterey:       "722379fe3a576946bff1f7406f0606e604ad80d855be5d391174ac27d843491d"
    sha256 cellar: :any_skip_relocation, big_sur:        "722379fe3a576946bff1f7406f0606e604ad80d855be5d391174ac27d843491d"
    sha256 cellar: :any_skip_relocation, catalina:       "722379fe3a576946bff1f7406f0606e604ad80d855be5d391174ac27d843491d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a8bbb832d2ee1c9e438fc3bde6109343d4f59e7ce2c32ccb56f06c46f334643"
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
