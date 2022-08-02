class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.4.tar.gz"
  sha256 "475ed2f6105c335ca38d3d660bf0057c1876bb0f326a8d64ff3f0d5d360648f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "442b7f6467751f4a8985a7e9106e274f08b127a9d5a8d5f0cc4ff7c0d50eb268"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "442b7f6467751f4a8985a7e9106e274f08b127a9d5a8d5f0cc4ff7c0d50eb268"
    sha256 cellar: :any_skip_relocation, monterey:       "32ddad3e6b5bb96d0f2c279655e7dacee8b24ab87f5cc34356ae233451875ab5"
    sha256 cellar: :any_skip_relocation, big_sur:        "32ddad3e6b5bb96d0f2c279655e7dacee8b24ab87f5cc34356ae233451875ab5"
    sha256 cellar: :any_skip_relocation, catalina:       "32ddad3e6b5bb96d0f2c279655e7dacee8b24ab87f5cc34356ae233451875ab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24c4c7de439ce729b0f5c576fd3e0de8945a30e74aea653d80cbf36376d9e478"
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
