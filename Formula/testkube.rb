class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.24.tar.gz"
  sha256 "d831e555a10f1f352f4a62607094bb0a8048224db52e4bd47dd59f7ea05bc0b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fa694359d3655e830ba308beb5ab12e325b7390fa22e466d1792b9f7b8abafc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fa694359d3655e830ba308beb5ab12e325b7390fa22e466d1792b9f7b8abafc"
    sha256 cellar: :any_skip_relocation, monterey:       "f7063ead51c5b891cbf3c8c3a736add3a6e4a4d0a9ae0b61141761cdb8721edb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7063ead51c5b891cbf3c8c3a736add3a6e4a4d0a9ae0b61141761cdb8721edb"
    sha256 cellar: :any_skip_relocation, catalina:       "f7063ead51c5b891cbf3c8c3a736add3a6e4a4d0a9ae0b61141761cdb8721edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fcd4353c2fc99f1179fe2d284d010fac221df9ca4bf0cbfb66461829597650d"
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
