class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.20856",
      revision: "991bd2aae331cf5668175acc77c7c8fb8e49accb"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "049da0b8013f65f982e90eeed797c8399868b442447f8a253f7abfeeef08b024"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66ba137f008d47df805bdcd2f387ffcf924aa68576663ba36eda1b3ce4da8060"
    sha256 cellar: :any_skip_relocation, monterey:       "36113bf88d6caf1ee109c83950d9f691f06ebb0d2d8ebba4338d9d73ffccc057"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff4b2cdeebcf8a9b729af4f7b48d3b8650752dfb256932eb4663067f49fa88b7"
    sha256 cellar: :any_skip_relocation, catalina:       "f29bb00d24a657fa8aa6cb4e22cdb8eb7405a4c82062e6e67d886b4913522d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc49955b050439c9e1301a5749020da26c05cb8fe86bc076542c843feb8a1a02"
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
