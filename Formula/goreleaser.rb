class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.171.0",
      revision: "097c456a3b4f8f522a9d168bfb4f6a5d2661e659"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a16d984f5b5afd06f4c62e4ac5ad2a5d555dd3125e0cc05e6268efd2ec1e421"
    sha256 cellar: :any_skip_relocation, big_sur:       "d03dac689d0f3abd42c680f2c531b9ae2c1e39cda83b1d82696608094b3a5d5e"
    sha256 cellar: :any_skip_relocation, catalina:      "672124163820ac7367b4e87f9f6454866c1afa8d821fd4ef015ac0441fd782cb"
    sha256 cellar: :any_skip_relocation, mojave:        "6b97b8dcc6dbc39448ac52566611707dbf2410481936fe5d39048df442a8f93d"
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
