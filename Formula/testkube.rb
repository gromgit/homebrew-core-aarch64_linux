class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.1.9.tar.gz"
  sha256 "754b6088d5b43e589cf64292757945a750d6809eb796c11de554e074a7ae9873"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfeb169ff0d279e7ccd20a6fff5ae99a074b8f4d8223d0cf5a45d9293f07a909"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfeb169ff0d279e7ccd20a6fff5ae99a074b8f4d8223d0cf5a45d9293f07a909"
    sha256 cellar: :any_skip_relocation, monterey:       "f44574dfffa07ff4223667362d7b7d72c8be8417030a46b8476a26134ee4801a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f44574dfffa07ff4223667362d7b7d72c8be8417030a46b8476a26134ee4801a"
    sha256 cellar: :any_skip_relocation, catalina:       "f44574dfffa07ff4223667362d7b7d72c8be8417030a46b8476a26134ee4801a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fd7de9ae45b60ac79fa322183d0243689e79e48c8c36486251f85a347c72222"
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
