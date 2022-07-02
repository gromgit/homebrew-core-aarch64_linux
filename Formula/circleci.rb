class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.19492",
      revision: "859abf97f18982f0e4f4eb1e6e1768795e726c84"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2ac91b125b10c4ab507a72b497082e487ae754b5c62f5a344dd6cee8c7d20ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7fb9770f1f4451266aa3bdcc1b466324c1654001e8847645760da792a7c0412"
    sha256 cellar: :any_skip_relocation, monterey:       "c09cfaa81ca951b487b495f2093cb69d74cae7c0f4eac5d7b35753f9bec5cfdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "20616e41d4a84c3c148dca7582ba75d5e6fd91cbd1e64c17c76832ba2449db90"
    sha256 cellar: :any_skip_relocation, catalina:       "6d28b81b9cd3e5bd312a791dbf8eb445f09d49ae8af6a0cee7df821dc83c3f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1ae0d6d4b80b47b46a888f48e877afa5592334860e1f7ccece0998a12de2da2"
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
