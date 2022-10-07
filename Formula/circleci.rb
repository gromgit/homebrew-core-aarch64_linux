class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.22150",
      revision: "37e2fc36d336b0f20683efc21205d9a7ba299516"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "320c3ef3d223839c32d3c4f2c5ef22e92244da7857d0a8ba02e2a451075b6907"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79e47580198d569907447ccd14aee6120360d7de03bed30db1a8c16cceb5b304"
    sha256 cellar: :any_skip_relocation, monterey:       "b7439e6abfcf6ccb588249a99e86d438d5f228053042e64f4e98674c67849220"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c75d4ee1cd92d540aa370bbd103b49a5530c7983df5467fc38cc50cbabe2d7c"
    sha256 cellar: :any_skip_relocation, catalina:       "ba41b1ab3ade420773039cfe243e40e621507bbc3cab382aca718e87fb27c072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e97d656d0c7b3fb529da27747af103a9161ec780ffa76a26ac46d6cb3a51c58e"
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
