class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.16422",
      revision: "7ce53877952ebe083438e822d93d8dbf8c921f18"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f39684ba7f0bb488ba4db81ffad10ab4b8c8f2039f088f5d9f1d9cac502fb358"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64002020a71464bc3118f36751f795ab7b2476ea2ebaa8946c4788ee2e49619b"
    sha256 cellar: :any_skip_relocation, monterey:       "4bfc7698b60d42bf9a8be938954e695e5b25972c7830468a29ef8532b7d4ee46"
    sha256 cellar: :any_skip_relocation, big_sur:        "81325ce63c2c593bf4c7c07a29ccde215b37bcf211fcaad7643a2836366341ac"
    sha256 cellar: :any_skip_relocation, catalina:       "062590bd0638d18cf1c8650ab2adbd4d50ef4250a9f4bc53ba4a26cc1ea21478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d19ecc0d6ca820e77af80e7037ec64fdfae9f85010258e3a55efbeab78ee5357"
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
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))

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
