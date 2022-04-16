class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.8.1",
      revision: "3663ec1b13a6b50e225b95d8ce0db1f63c61c9ab"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30aabda024fdceb26b2b6a692a1ec6487d1472ebe52d381009738cb4cd1ad29e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a246a9c784f88ac85938b6b00f8c587c0e6b21105714bddabd2e32c08b13e170"
    sha256 cellar: :any_skip_relocation, monterey:       "9b64fe725c1aea9cb0c4b7730c2f5c50084a930b2ace79e4b62ef54dcd8fc396"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f82bc64994fc8f056a3fdc47d16b8d9b6542d6f6f23838613456ed3a5266e55"
    sha256 cellar: :any_skip_relocation, catalina:       "d88a428e225b58f0e24f651ce024ba0b80ec8eb5e3c4b4c21a523c5c9aa6f59a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c88452e1a92fe7d38ece3ca6103148027838b2ffa4e3aa55c4a97d1ac4fb996c"
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
