class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.168.2",
      revision: "39e57929937d9b992a6d44b67c42fb222e34043e"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cd8e568feb3b2cf72edf0f431209c955d98e12e06eff7f1f54ba1d69dde31287"
    sha256 cellar: :any_skip_relocation, big_sur:       "24dbcf37d1fd8e2d9d54bb85073ac2e185a3c59fc5521b2b8bee421d49b592e0"
    sha256 cellar: :any_skip_relocation, catalina:      "56c8cd42be002866cfc0b6e20611e22b1980c928e82f9642fb34d1385461f669"
    sha256 cellar: :any_skip_relocation, mojave:        "02627c3910ea86f5877a74e0cc5cafdee429ce042fe13d569eee0b22dcdf048b"
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
