class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.21091",
      revision: "45afa93d0ae256aded8a2c3bbd3daae8adfa8842"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fd0d01a820f739d657e800c38243f3abb43e7a502577f9e065cf9fab71e44c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a79dd7860d62769d9ce0fb8e70cc88b5ebb6b5d1033a3d355169df8ab47dead1"
    sha256 cellar: :any_skip_relocation, monterey:       "55c405654223868003547b805747272a6dadf6999fb19073573e5cb029ccc6c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8284de5193b556b9364a643fe91dfd614d5afd031ee1b1aa0ff5ad18886d030b"
    sha256 cellar: :any_skip_relocation, catalina:       "0cd79d7af9d3e15f40b05f2df6a24ef69c3fdf6835e3910d1c3abf78b6ad83f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08ae8b45365dbee4a76f0eef0ee7e20c191bee9ae385217332d8632af3bf8352"
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
    assert_match "update      This command is unavailable on your platform", shell_output("#{bin}/circleci help")
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
