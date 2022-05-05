class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.17497",
      revision: "77066e803c166cbad4634eccfd3626eed8ed2eac"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d893dade6ca5104433568a50262e98ae920658fcee01938718321302d326e79b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1121fe44386ffe2af9547dc65a86d14cbd87f58b50687d4796fa27ac5ae06a6"
    sha256 cellar: :any_skip_relocation, monterey:       "ee5846ab60f48abfc67c42561aaf9720898458884ce3599f72bd3ec84cbf82a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9772ed1e5a2f23a9e38a8d03ad7f616df422c4b7d7f8962e21bd43ee705609d8"
    sha256 cellar: :any_skip_relocation, catalina:       "8220073bee334491aa977eca685325028fc25ea7bde915a568b5c7d51ca1bf6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "199d2b95b66003eee187b003cc00b51623cac71cb61fc0e06ad487f92210fc0d"
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
