class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.38.tar.gz"
  sha256 "18a93b9ac42f6a26770f4c72c4128baf9e9d69165eecc80aa9a4c3c2abfa9848"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e75580a4dd70d7bf73f4ecdfb5b14818e80336d459f98838eca67cafcfd0f458"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e75580a4dd70d7bf73f4ecdfb5b14818e80336d459f98838eca67cafcfd0f458"
    sha256 cellar: :any_skip_relocation, monterey:       "3ac67794429eefe54c9fa721b452520bb9d9191bac635e338da370558f874b91"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ac67794429eefe54c9fa721b452520bb9d9191bac635e338da370558f874b91"
    sha256 cellar: :any_skip_relocation, catalina:       "3ac67794429eefe54c9fa721b452520bb9d9191bac635e338da370558f874b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd2ae82c46db01242422dacdd29a3be2de634f788ebdf716993fc95faa2e40f0"
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
