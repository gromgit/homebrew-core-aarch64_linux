class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.5.1.tar.gz"
  sha256 "b90a2f930b585b6bfbe10ab6f6bc89ceff223b13a5700340c8e0d162a321bb61"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b682c517893fc7a72be9da9fe8df25f4fd68e07a2a67c30fc4791b3b9666e8a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b682c517893fc7a72be9da9fe8df25f4fd68e07a2a67c30fc4791b3b9666e8a3"
    sha256 cellar: :any_skip_relocation, monterey:       "5fbae0c2f52f5a6ed5fdcc8c6a0bffb640c6b85eb5e4736ec1629fe2ad5cd784"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fbae0c2f52f5a6ed5fdcc8c6a0bffb640c6b85eb5e4736ec1629fe2ad5cd784"
    sha256 cellar: :any_skip_relocation, catalina:       "5fbae0c2f52f5a6ed5fdcc8c6a0bffb640c6b85eb5e4736ec1629fe2ad5cd784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11a9bd2bdc2adeb3b40159f18e8e4dffa59dc9f19c511456efc311bdfce06e3d"
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
