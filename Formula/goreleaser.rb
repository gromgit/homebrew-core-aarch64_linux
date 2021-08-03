class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.174.2",
      revision: "5227ef0c245de76da6e80e0111ed303252731b8c"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0f257e3b9e812c32aa934577f595aa384161ef6c64af280b6a809d17c195b5f6"
    sha256 cellar: :any_skip_relocation, big_sur:       "143fe3604c1ba47069f1e08fcb8ac992d0bc04bf4a576f8a0fa6d15331b517c0"
    sha256 cellar: :any_skip_relocation, catalina:      "a01e42b5e3678e1c2a90d9946641d903802fc059af636dfa83591ed699048a02"
    sha256 cellar: :any_skip_relocation, mojave:        "c49ad0d31bbe211781fc47e3ecfa9cae09679dd2890ce25f53ef9241aeb7e742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d6f3fb5d241334685000b6bc8d22473437ca3646517a9e42fb8968e3517c893"
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
