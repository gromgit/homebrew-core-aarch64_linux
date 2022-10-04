class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.21898",
      revision: "d66718f04d668e12c7bae908d75751637d356a00"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7974c3f024c5896275cdf450e1e9fa384e71c9228c7b66cd93c7a21f2fc44c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df6cafa664ec8e093d4fbeb52b986dae946506cb2f7572a176950bb6939621f4"
    sha256 cellar: :any_skip_relocation, monterey:       "f0ea0ccc1aaea56ae1ea2515575e34e3c1c9ad4f38c5d5bd6467e98b44fc4d1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f6446c57f1376e55ae49b15ce010d8fbec784c76aec0f71802608046daaa868"
    sha256 cellar: :any_skip_relocation, catalina:       "f03fc59be34faba8e7cc2978e8b7eee5aa2e858005c980e3a8597fc33d5ca1dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "453d4760ad53b91174085c76e154395fcb242b123b379d299a04444e6c136129"
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
