class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.1.9.tar.gz"
  sha256 "754b6088d5b43e589cf64292757945a750d6809eb796c11de554e074a7ae9873"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76cba4499400f83265e3efab9343d0a9d79070b46785f01e232e1fa4ea4618e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76cba4499400f83265e3efab9343d0a9d79070b46785f01e232e1fa4ea4618e9"
    sha256 cellar: :any_skip_relocation, monterey:       "a57a41cb16bb37fe99c2b37782d3a81c6c625564e6c4750f06639fd5e8244dee"
    sha256 cellar: :any_skip_relocation, big_sur:        "a57a41cb16bb37fe99c2b37782d3a81c6c625564e6c4750f06639fd5e8244dee"
    sha256 cellar: :any_skip_relocation, catalina:       "a57a41cb16bb37fe99c2b37782d3a81c6c625564e6c4750f06639fd5e8244dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acde8e171763abcf01740c89c564a44657c560670933677d3d44bb59aa3945e6"
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
