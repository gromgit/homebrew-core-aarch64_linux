class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.7.0.tar.gz"
  sha256 "56f6544389c168b7876c0fa31d6c780436fc6bcc51ff295e1cb64d1100340caf"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d980ac7ab7e0bbc410ac7d275eef3e558c89dfb1f4e9f9821e99820617e784e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99b4895c1c24fa251615d417c75e4d2f72a98d95fc639f56539812073dccd326"
    sha256 cellar: :any_skip_relocation, monterey:       "f6942bcaf801a8c8e344bed5188ccffe748a369c2ed6d78379f7ed5cf6f15099"
    sha256 cellar: :any_skip_relocation, big_sur:        "f845fd2c96c006731bb32c1b5b46561393f53afb2b14627898393eca43dfbf14"
    sha256 cellar: :any_skip_relocation, catalina:       "391be66baff5c65ba9c7b5ec1dad5eece1c4d3a79ceb1b77d0e0e48b24f3ce8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03bda27a562c2f6f97307df34839769809f2c092c8c57f40726c9d0d73e734bc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
