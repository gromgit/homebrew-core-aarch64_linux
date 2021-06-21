class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.171.0",
      revision: "097c456a3b4f8f522a9d168bfb4f6a5d2661e659"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5c96a9172b50be83d159d5e2c1114f869778393da09c182ecff71d89d1982845"
    sha256 cellar: :any_skip_relocation, big_sur:       "d174eec35c995aa27033d53337d78227f28d3c69f2dc88d2b1749d060ac15e0c"
    sha256 cellar: :any_skip_relocation, catalina:      "03d9ca7b6b9e3ecb4d9420de02661e849ee6391891c64293f8114db731e5105f"
    sha256 cellar: :any_skip_relocation, mojave:        "1346273ab321d9b92814ec9f623ecdf0099ad234c9391fd012ca854e8c3cbad6"
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
