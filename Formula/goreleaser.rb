class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.166.1",
      revision: "046c60d20dc37ea23daa23eff328cc8b15ac7c67"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a025824ed67630ab6fb931bb63a777bee1cebce146bf3269f9be434e8df77d25"
    sha256 cellar: :any_skip_relocation, big_sur:       "dd16f4cd5294113b2c48c037516b6ce7f5d4a4b9458ee2e9c59855425b856060"
    sha256 cellar: :any_skip_relocation, catalina:      "67c80b3c28b19e96d0f67482db283304638090c4baf82ec9daed73fccd348f20"
    sha256 cellar: :any_skip_relocation, mojave:        "c496cd1e240f4e5b8c6b72851ba2b65a00c9c4b90b11c170a0464b68d4b7d788"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=homebrew",
             *std_go_args

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
