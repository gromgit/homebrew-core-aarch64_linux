class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.5.30.tar.gz"
  sha256 "160ae99150a648523da257f418afa48d4b443c519492803f717a801bedcb15f5"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fab75eee6305bee06dca8f744ba9b463e18f8d711e86bdc280ad0a9912fc1988"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fab75eee6305bee06dca8f744ba9b463e18f8d711e86bdc280ad0a9912fc1988"
    sha256 cellar: :any_skip_relocation, monterey:       "f98ae684ff7dd32052df9880c14bf6ba6ffd27b232905045e8e2d52426cf10b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f98ae684ff7dd32052df9880c14bf6ba6ffd27b232905045e8e2d52426cf10b2"
    sha256 cellar: :any_skip_relocation, catalina:       "f98ae684ff7dd32052df9880c14bf6ba6ffd27b232905045e8e2d52426cf10b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b7ee3dbb8676e6e478625aefefd8bc4d0bd3ff0c65ad364d8a3fd1c804b3a93"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
