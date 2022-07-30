class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.5.2.tar.gz"
  sha256 "6eebe6e5bb7ee5f69c1fdca28dc6d334298a84e39291b9a6f6db0d4a73a66ff0"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64f1c1d8ef77b163892f043f60824d8c1f39e1aba25a06bf71331ceeb4c528d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aaac34e96ed77be3f136b2c16f2a668a298b2cbd0e229442d33f4c7315deb054"
    sha256 cellar: :any_skip_relocation, monterey:       "d3359bf3a40a452f18c4ffb12a0f3fd078e19788d129a8a87f998cd0e1a6791e"
    sha256 cellar: :any_skip_relocation, big_sur:        "54021a6510dfbb94a8c998fa8c2570a1eceec7f2be1657dfdb28d3b3a46f568b"
    sha256 cellar: :any_skip_relocation, catalina:       "8992642f74334cad4cd51cead6f66d941dffd604b5e237a9bc2637ce4c6e4db8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8a67fa2d7176067f56a3e90fbca43224f063a222d08e359bc639e849aa7f609"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    bash_output = Utils.safe_popen_read(bin/"okteto", "completion", "bash")
    (bash_completion/"okteto").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"okteto", "completion", "zsh")
    (zsh_completion/"_okteto").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"okteto", "completion", "fish")
    (fish_completion/"okteto.fish").write fish_output
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
