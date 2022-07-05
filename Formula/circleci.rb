class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.19603",
      revision: "ee1f05455ec36f2e2fa761f0e3ffadd3684f5273"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df95998f03f5d4eb72ffd23348f1c2a1c8405a20e2be2dcb26bb69cfd2d79bd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c5ba1919aa865838f52348d4a58f9c10163f23c7e687e34d84d30c89b80daa8"
    sha256 cellar: :any_skip_relocation, monterey:       "6f4104d40fee416dffb14174b87f93d94a63c5e44cc0ca428d4ba799ce9ba343"
    sha256 cellar: :any_skip_relocation, big_sur:        "61f91132c7b08b3ddccdda07af1ef170e4d3bcf81eb5f0b7885fc864cf39a2e0"
    sha256 cellar: :any_skip_relocation, catalina:       "b8a2ab3872da0ec38cc2f07daff40b17a09b7fd1f0329b9d4e705b53334f2b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e8da2e4bbf976c006860bbc0ec4ab557ac601060be2cba4106e963b60427164"
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
