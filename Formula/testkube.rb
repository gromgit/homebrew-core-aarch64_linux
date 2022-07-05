class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "952a39fe0310687c275a3ccb35727cd1d6fc3b439845370ffd77cb9e95b7cf5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "211f18b374eedc9f537c2e3faafc3d6b8d9353ba410f310b2b1cf5b34294d1c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "211f18b374eedc9f537c2e3faafc3d6b8d9353ba410f310b2b1cf5b34294d1c9"
    sha256 cellar: :any_skip_relocation, monterey:       "60e53977f864a4a5f93a12e20abb5664e7a002e3b5b4c531375503e57440d664"
    sha256 cellar: :any_skip_relocation, big_sur:        "60e53977f864a4a5f93a12e20abb5664e7a002e3b5b4c531375503e57440d664"
    sha256 cellar: :any_skip_relocation, catalina:       "60e53977f864a4a5f93a12e20abb5664e7a002e3b5b4c531375503e57440d664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29afeb76df2cd26468f3d431d43a0e48de0c1f683a39d5a2add44349b764a941"
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
