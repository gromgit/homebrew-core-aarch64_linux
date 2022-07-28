class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.20374",
      revision: "f06195a6d2624456612feceb7c0996e56bb51a13"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9475bf6b9982211b964bc0c8af01353f76208ef9018927cb36c5d30f9f40ce8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92658aaee3f6a84e58ca9aea9bf21ba2ba62d48d19193f8b97346224dd5a599e"
    sha256 cellar: :any_skip_relocation, monterey:       "e00386f60efa009b99669b483ad1b32a68bf575eef694e0668d6265d202b214c"
    sha256 cellar: :any_skip_relocation, big_sur:        "95a34a09e9f48d9e3bb27278e56132f97ac31061b8f0315c726ac2e3d4dab22f"
    sha256 cellar: :any_skip_relocation, catalina:       "a1670c11209ee6df33b61024518b5758832190d2b616189710b4346d7a9ea168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7bd8b6cca365d28c5e5853779d4c0ee935b8c668bd19d8c42155527ad90e658"
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
