class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.0.0",
      revision: "4bd0b73e95e83cfaa51b19330c4b039d1d7c0d09"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "925a3c334003df1e932dd13150be066027a6221c1a171af932b4cb017a49b41e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96a79830946576ae6c81b7ae26a4a9b57b31dc6ac1f6bafbec400a322627fb50"
    sha256 cellar: :any_skip_relocation, monterey:       "bc1def1ef9491df1f41958d7df5a740d95bd3abbf57642f02b4c2d8929011d67"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e29c239f36e375ad0683da6910f8e39179ee920c77a4a8769ac85ca1410c68f"
    sha256 cellar: :any_skip_relocation, catalina:       "5f704e185ec611809b4d2fe7d86fea3ebaa4816972d3f2159fdb5d3bb908743d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36d2095be7742546fb8a7d6ffc8a39c03c23cee286fafe462a44a6690c01b585"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ].join(" ")

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
