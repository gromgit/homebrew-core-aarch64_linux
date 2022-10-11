class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.22272",
      revision: "cbf9fecb0c8232c997ff959998b359ec60a0c746"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d014bff287d2065c696e237107570ce3f1cd286b6cbc76889ec6f9015f134062"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72eff09cd393e8e64ae85cd96457769ff20671bf7fb733bdb964b10ab1fd5f2b"
    sha256 cellar: :any_skip_relocation, monterey:       "f047e7619fd93b668d03e11eace0c6ba272a280157b3bda772bc5b9c41f3fc6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1723e3925e2f7174330184db255411c197da891174475a8ed945fe1de8a2a49"
    sha256 cellar: :any_skip_relocation, catalina:       "910ec935f524d9c9cbb04b1a2b6c34ebf380f75ce391eeb957ad193eb4ed2f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c68978cde63049b8b0c8213cad8192b28585ad078c0220a830d9234e126aade6"
  end

  depends_on "go" => :build
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

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
