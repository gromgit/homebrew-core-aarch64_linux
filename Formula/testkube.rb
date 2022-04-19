class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "4c1e9636e0d4e0dbbb793f4d2ffca7fb250d28e1662e8e2623b24655397bf3ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c25f8f849e7e9b7dcd93a29bd918cf860caff319007f83c29e2fcbc18505649f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c25f8f849e7e9b7dcd93a29bd918cf860caff319007f83c29e2fcbc18505649f"
    sha256 cellar: :any_skip_relocation, monterey:       "39fcf175cdeceb3f6806f116fae97a9ca8511d3ae5e03c93d48de978747d7789"
    sha256 cellar: :any_skip_relocation, big_sur:        "39fcf175cdeceb3f6806f116fae97a9ca8511d3ae5e03c93d48de978747d7789"
    sha256 cellar: :any_skip_relocation, catalina:       "39fcf175cdeceb3f6806f116fae97a9ca8511d3ae5e03c93d48de978747d7789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "576c60d34e1725f8ca9f91f89d4bfff361d2819f563883efb3d369c10f2af084"
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
