class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.21289",
      revision: "3b49940db83d496241211861c4d3e209d48f1afb"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "164ea89e3e95188748e45276154a194e58ddf923f78f6472e204405bdb18607c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b853643acace1947e3dbcd2ee3aa6b1fbede30e6c2187311c827f838d223b51"
    sha256 cellar: :any_skip_relocation, monterey:       "186b02df73cdba48eaae47e4b8fcba458c73881e7570e40e0d4194ae7d4dd613"
    sha256 cellar: :any_skip_relocation, big_sur:        "c04a59adc26d396c317ba2da1a14decb4bd935bc13caf52759ecfd02e6a25a33"
    sha256 cellar: :any_skip_relocation, catalina:       "9dc97fe74b970b33be18dacbb964c5a60a77b52f082b31498f518bfaf5c113b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6042f826e9c62d541a338edb733e923f37b87ea8cb10ec84caa224acbee1ea3"
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
