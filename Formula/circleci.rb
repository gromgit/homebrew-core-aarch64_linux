class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.20729",
      revision: "0b26028c1a584b2ed1d227243244ab1ea346ee20"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb3de5fb1749228723affea2a453060eb23efd26e298d66e4121410255b819cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b39e43ce97a9f5820a0c372ee0cf1f2687f273e60e4002dd7f92094d13cdc4bb"
    sha256 cellar: :any_skip_relocation, monterey:       "c779f2b65dc71bffd8dcffaa31e21b45d4d15f9fb855c728777961a03e3334da"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b5b3b8b85fdc74b90bfcb3facc4e30d620e380ee788da966033a7e90656990f"
    sha256 cellar: :any_skip_relocation, catalina:       "19759a1fe2852001eb9b4cc7a1bd783375c818d39dc20a1fa84a111afb001c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bae91833dc30507f5d71967428a5c8d1a82aba3711b202347d9bc8a91a0dcef"
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
