class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v5.16.0",
      revision: "2ba14529b39056340e57400295afdc1dd46ae0d5"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1805cf86e2e135fd79ffe5f784f51b6e29107cf61934f8139b6f15f41808114c"
    sha256 cellar: :any_skip_relocation, big_sur:       "49739ccf043ed4ced63b48a5cb5f9d39df1ea9bd0277d46b2a90f4f4b5792df5"
    sha256 cellar: :any_skip_relocation, catalina:      "684a12c86935bfcfc932abdcc61b613ef255b2fd84666ff11bceccb18a13cfed"
    sha256 cellar: :any_skip_relocation, mojave:        "5e4d30e74bc2d46e3b1a5d698dbb0ce5eec30d8bf54c1289c7eaf14f91b9f336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eac00706fd4d55d196aab96960b3b01720a83424fec10e51753904e4a7dca84"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
