class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.20239",
      revision: "571ae88aea10d2f551932a3a901d0591ccfa2b28"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8563cbd8959b7088bd10ef825efe452bf041890005a0d14b537e5bd85121373f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cc5c38d5240f30c046e473d5d00cf0a36578bb78094a88e4e03105c3727d93a"
    sha256 cellar: :any_skip_relocation, monterey:       "9a37d712120d6252faf21ded595900201c7f1fa97f2528b802aaf668ec253cc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "32feff31d1ce505a028204a30103a9c9facf8acbf4d1c7d0028be5c5fcc2b6a1"
    sha256 cellar: :any_skip_relocation, catalina:       "fdae9911a6c77870d4ef4b31e0a8d4c959b9db0471cd75f2c670eed6d464cbb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85dfbf272ba8c2ef24a1087bfe207b931c041ba0317c7eebae20d2c83150151b"
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
