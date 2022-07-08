class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.10.2",
      revision: "de3f381f55c88014b0d0eba91b28923eb1a992ac"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a9d8b07abdb98f7e601f228be033d8939182401ee8a93f91ebc0ccb9497e21c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e945c54fa2afaa2ffeb3726d9471d0e60d5050a4b6236e929907a73c2a0e9c5"
    sha256 cellar: :any_skip_relocation, monterey:       "a44d114721fe12c91d3361a15553acbd8cf85f5ce62d8d0faa8b9461c2a795d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f79b91c7091574e5b4be304a786284a6796f2919e6665de4e938deafbbbc143"
    sha256 cellar: :any_skip_relocation, catalina:       "c27d1427f13ce0d646a15249fc3229b53f778a6d54882b8e90e45a679ff83dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3be33f5458769debdb3002cae951f7f6cac21cdde6b7b2378b204b8980faa426"
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
