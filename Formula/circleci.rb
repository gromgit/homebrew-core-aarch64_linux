class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.17142",
      revision: "0ae0a8417ad6a31b58e9de93295c2c1e99dbbb3e"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5527ff3137a41b78a1aa15ba2efcf319f56f36aea582d124f0b8e67d3c7a50d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21ccd81ff637a0c5ce317de38a28612114a5e5137ba01176c3a98abbf87fe0ec"
    sha256 cellar: :any_skip_relocation, monterey:       "3bb2fcf1ce507a8d7d4b4d0dbfa7abd0d574f4203013bace3c0332e974c3e891"
    sha256 cellar: :any_skip_relocation, big_sur:        "49891875b54c87b1c9883fcd7dd1b6ac3d9f7fa129d30bf9983aec8c72882c2a"
    sha256 cellar: :any_skip_relocation, catalina:       "5c45ced4b268ef2ec2d649fbf0c6a75ceb59fbd926c6cdf08205c30344ad2730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41581aa8df9839bd6b2572339daeae4824c880e7145054c813eeb4e5b63f7bd9"
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
