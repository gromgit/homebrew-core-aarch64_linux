class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.21812",
      revision: "72528b8ec979662afc627984d4877faf9a6e830f"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c39f78d19da55d71d85ab6c1138e5c84ab99a2b803362689c2429168173a1e62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1c90cb0fb7c362271c92556b4b08d57fec6fa47d7515f670b9499c8c57e6d59"
    sha256 cellar: :any_skip_relocation, monterey:       "0cba8d3d3d2a06e68369da1e87595500600721769b521a47e990ffbc8a4dfbbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "67e13cf0dd41c018add3e8a8b869c24a7f5069aa66eb9f14d995d047d82b3278"
    sha256 cellar: :any_skip_relocation, catalina:       "1a50ac8376e5967dac03cbd30bd361ffde48c8ba73d6370539e70ff5e61249a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66406c942214c7fdd19d2b8c690096716f0f02f5f74d3c539f122013bc664c38"
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
