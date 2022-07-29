class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.20397",
      revision: "366cc5413053ee41072fbc30640b5fbe09870d14"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c5be32529aa9ebb84a09515f12d99a72826853a910d77d572d297346e55d942"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2a91e4395ccc8cc935ce508f281785cf13855e25d0a20d0d2c37dc24f857036"
    sha256 cellar: :any_skip_relocation, monterey:       "9fa086a911bca5329b627a0a9393151deba3b6a6f3b17acb7e41e93a950f76da"
    sha256 cellar: :any_skip_relocation, big_sur:        "b972401f32e873f8c7d588f98039cdaa07b50b7d602eb43021a417d2d42af0c5"
    sha256 cellar: :any_skip_relocation, catalina:       "24aeae2902e36d0165a50bb81a003496f8ec6edf242416c6d3874110ff4ab0b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "417c838578ba09f1736b381a6c29dec92a310b6c59ee354854b4441cba41161e"
  end

  # Bump to 1.18 when the x/sys dependency is updated upstream.
  depends_on "go@1.17" => :build
  depends_on "packr" => :build

  def install
    system "packr2", "--ignore-imports", "-v"

    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read("#{bin}/circleci", "--skip-update-check", "completion", "bash")
    (bash_completion/"circleck").write output

    output = Utils.safe_popen_read("#{bin}/circleci", "--skip-update-check", "completion", "zsh")
    (zsh_completion/"_circleci").write output
  end

  test do
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match "update      This command is unavailable on your platform", shell_output("#{bin}/circleci help")
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
