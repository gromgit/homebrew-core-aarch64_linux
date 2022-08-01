class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.3.52.tar.gz"
  sha256 "932fca19e0604719607845261d69454f46679167eca8e070cbc58a6cdcd38fe8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29c4a64367ea34d9fb20720b17930947968b715c39cdbbbcaef3d2a4862acdc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29c4a64367ea34d9fb20720b17930947968b715c39cdbbbcaef3d2a4862acdc4"
    sha256 cellar: :any_skip_relocation, monterey:       "98078f99bcd3d667fa243510cdf4660b8022b3be01bf13ad1954fbcf82e7c916"
    sha256 cellar: :any_skip_relocation, big_sur:        "98078f99bcd3d667fa243510cdf4660b8022b3be01bf13ad1954fbcf82e7c916"
    sha256 cellar: :any_skip_relocation, catalina:       "98078f99bcd3d667fa243510cdf4660b8022b3be01bf13ad1954fbcf82e7c916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf57ccb98524970a8dbf9626384353f5179ae8a2bb00765a8674bda306e72f5e"
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
