class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.30.tar.gz"
  sha256 "179d1d5eda13e10dcf126bbbcd534e43067d9a794251a45fabb87052d368cb8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e59eef1f65af339ca0fde3cedf21b24db7b50a0cbd1e67791eaa91beff4f8523"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e59eef1f65af339ca0fde3cedf21b24db7b50a0cbd1e67791eaa91beff4f8523"
    sha256 cellar: :any_skip_relocation, monterey:       "596513d412c26afdaad5db6f2820c9ce776fee3160de55506c7086ccdce1d22e"
    sha256 cellar: :any_skip_relocation, big_sur:        "596513d412c26afdaad5db6f2820c9ce776fee3160de55506c7086ccdce1d22e"
    sha256 cellar: :any_skip_relocation, catalina:       "596513d412c26afdaad5db6f2820c9ce776fee3160de55506c7086ccdce1d22e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7c2a5bcceea63b4747ea63a79fa95cbb901444ae3a5f79b33fe70d343241cad"
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
