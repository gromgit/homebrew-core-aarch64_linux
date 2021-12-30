class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.2.4",
      revision: "cdcaf038c840247531576a8dd50f30e1615a988c"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "759776639fb67a1aed628cb8f46e78071ddd010515bac126f108041aad005612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f39b8ab8ea03bd86623e1d5f3e3d0aa2a182fa8820429b84a387245d3712fdda"
    sha256 cellar: :any_skip_relocation, monterey:       "2b34a59890f0a5668cab5f18708f884d61ed1f93c6129877d368ed829d6b4bcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "16c8773886f985fed149324a0f71e67f1d41396bd46afbf74d769b482666e22c"
    sha256 cellar: :any_skip_relocation, catalina:       "7bcfb100e36f088ef17e5c5449e3559c669b6f8620d275d4ce7cde369c9408c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1808dfbe83c46c94d39846943657d5c2cd4b138b5f3701d791a6c77b2811906"
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
