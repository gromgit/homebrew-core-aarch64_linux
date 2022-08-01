class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.0.tar.gz"
  sha256 "519df319fd69924c1f2b93ab43e624a8d8dcc1f4cbefd9a4466f691cbe5aa1fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15dea6245b37117561beb29e05d34adeca9741917d3718280f49a46dfd8ccdc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15dea6245b37117561beb29e05d34adeca9741917d3718280f49a46dfd8ccdc4"
    sha256 cellar: :any_skip_relocation, monterey:       "4cc3f14bb1b718dc59c42a102baa18cbdbe1dccb2ee5d83c2c8f796466d771b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cc3f14bb1b718dc59c42a102baa18cbdbe1dccb2ee5d83c2c8f796466d771b2"
    sha256 cellar: :any_skip_relocation, catalina:       "4cc3f14bb1b718dc59c42a102baa18cbdbe1dccb2ee5d83c2c8f796466d771b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67cd2fc8343d384de59d20f3183154ec33c62bd3b562bf622a594ed0f68e023b"
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
