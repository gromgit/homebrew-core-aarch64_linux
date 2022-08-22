class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.20688",
      revision: "168582f34e3efa133c0eab7bd51df2b6c1857c6f"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a386cf77eb3766dd6edd9481e1afca710fbc9d3b28a73f2aff4332961694d722"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b3e00e9465fb309cd84df74f581a551932f7f86a8176fc72d7f3db8732b27a8"
    sha256 cellar: :any_skip_relocation, monterey:       "5d58f515c6f528c1a89f08e0dc6b3454f637614d784bd3b4f7cec735a2525aa7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ebeeb3472976e16ddb9fad6e16f2fc7a45b564dc58bb7ede45181aeb6b5bb19"
    sha256 cellar: :any_skip_relocation, catalina:       "855edb6f54341b7b961abc05dc7ee9b6a9282aaa5e4170a05fce2b2b57024759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a27b7c756cc7af8c6030631dafd74821d6f8437f31f68798e7f99daa112a744"
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
