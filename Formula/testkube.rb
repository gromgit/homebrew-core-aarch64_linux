class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.3.52.tar.gz"
  sha256 "932fca19e0604719607845261d69454f46679167eca8e070cbc58a6cdcd38fe8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e122b9fada5ad0d3477db38bba302600e1f7313faf6c1a42d170e57eb40837e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e122b9fada5ad0d3477db38bba302600e1f7313faf6c1a42d170e57eb40837e"
    sha256 cellar: :any_skip_relocation, monterey:       "3460f84caca0883f822f95f380320ccaa22985ea96fcf7969297cb8b9a71fde6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3460f84caca0883f822f95f380320ccaa22985ea96fcf7969297cb8b9a71fde6"
    sha256 cellar: :any_skip_relocation, catalina:       "3460f84caca0883f822f95f380320ccaa22985ea96fcf7969297cb8b9a71fde6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5de54f44d6b7a87ebf9c2939309f052f25ed5d97cd7ddfe993a5445b1afedd19"
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
