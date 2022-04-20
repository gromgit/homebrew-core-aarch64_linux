class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.8.3",
      revision: "63436392db6ac0557513535fc3ee4223a44810ed"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62e011b601f0b954797fb64daea86a02e282b260d3ec9f7e0b75241558109496"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c25ded90f0d6d59a43e5348f6ca6131d58deb7a9fab9affa390f04228873c9a"
    sha256 cellar: :any_skip_relocation, monterey:       "072c7a210d96ab1ec5489177bd69a5c9e9b8e7a93081a4f811385a16d70f91cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "c37b3fd32224437072e7d45649a6edaa393eae7e74323209bf4c48b719eb432d"
    sha256 cellar: :any_skip_relocation, catalina:       "49b67e81dd6797e30df19d3d33ad93a4d2e1cdcc7f5517222a9ea92de5034c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2488ca9af8bc002072a3901055fa268a920ccb6632817d98ed036636795dc123"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "bash")
    (bash_completion/"goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "zsh")
    (zsh_completion/"_goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "fish")
    (fish_completion/"goreleaser.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
