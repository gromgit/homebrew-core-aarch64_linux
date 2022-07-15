class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.19878",
      revision: "e4216bdcb0296b665d1ecd12f65800feaca7b75e"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3cf8bb49233d0ecb70fa4b35af924cfe792f15411f234cb762e7eafc2a3fc63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dd8f3a90255201f2b381fed6b13d63cd36d8a477e2c4b57e6fc82cd6c086553"
    sha256 cellar: :any_skip_relocation, monterey:       "2a714009cc3063df8190265b0a6ebcd4f623211bb645d1a3676e441f50466845"
    sha256 cellar: :any_skip_relocation, big_sur:        "827def1db046c095706d0fda067d02463331aaa309382d116c8d52cf6e3cb667"
    sha256 cellar: :any_skip_relocation, catalina:       "e3ae01bcf5b925e5aedc0fa3407a5d71cf5f62f32a75e3f7c482b798b0df61e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7947ca3714ea7c7372f610cbb733811b03a6ade2113583e125220a53fa65d0e"
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
