class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.10.1",
      revision: "5a6dd2fbc89196cd1a1f5f0833dbe7db28686a5a"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "568e45fc080c75c7427399a8fabe9e54a447fdf4a7fd43128d48a0ef88691bb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fb0acda4b131f9bff05a8e96d74cb3902be7f65007ca3ac59f8b5e4d896e725"
    sha256 cellar: :any_skip_relocation, monterey:       "677bbee1362ecceb5c06293ce05d6da317c8c868e60ae7b6e240dec062285b6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "118cb1a35d6384b234dae8a2a9de4bd8fe6fe7a81019720ad4786a04c7959f63"
    sha256 cellar: :any_skip_relocation, catalina:       "e1ec6069119bc44c987d66dc733767cc166933ad158436a39e2dc6a8f760df86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dfb564b312d17127dd9ea8127aa136bb3e03727a41ad83f4e7cad6c25629ff5"
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
