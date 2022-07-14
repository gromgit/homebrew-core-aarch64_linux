class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.19787",
      revision: "e15f9169b140c964f218a2011031dbc585d5117e"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d60d229c497ac6783fb691210865f2d628a598e9ea09bac74202628104fc20cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f50c7d2d924a9acf85691cd6b21fa64320e32b64a20ea31fd8dd9f114d0ffbe"
    sha256 cellar: :any_skip_relocation, monterey:       "e1420284666ed17bec0e6e5378696d8a373ee8e5b87f4e3ea4f37e2b32477458"
    sha256 cellar: :any_skip_relocation, big_sur:        "df71d0c77acb6c5394e0445a32a7acc84452e42fe25b3cb2c272d0ed49cf6ea4"
    sha256 cellar: :any_skip_relocation, catalina:       "fbe7f8f15c9d16387dd00f03d135d3bf9ca6c4bd3ff5489a76887d02e98c83d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "304aeba11685f4a48c9c0e401e7608813765ef8dcc1d34ae576a757dd87ebb71"
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
