class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.20323",
      revision: "990c791ab36038b0ac3dc0d0be16bc840a11745f"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b4af9933d892438a454cb3fd5998ac4bc21b0012961f4ae2475ded82bc702b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf1d7e40fe8ababd76e576338c03a2dafe20b72dbd16c3d96d7891b668599089"
    sha256 cellar: :any_skip_relocation, monterey:       "aefa5c5cd06565280c38308ad0f1dc8cf7e59dc95cd49f0ef418864abd32732e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2860002f1d214d599ea175333c207a26b1aa233cbb5c78fd25b496100b66bcf3"
    sha256 cellar: :any_skip_relocation, catalina:       "8ae9e77efd959ba4d38ca1ac8f55de41ceff71b92ec2423ac3072f9df2d0f06d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d1d75ce10cc71bd1fff8b310a41c662dd1e29764f2817b7473556b0cc3bd18c"
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
