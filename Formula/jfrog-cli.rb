class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "09105873ec1fb8f7e34aaca8663d4f163d4b86f1432576ec491ee687bdb8af7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69fd4d3b8aad90f8df5bcc89349268180c44018a58a8336c104482d8280182d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "950d5bda56d5212a7da34c1386d7a6729feec385057e2d5a07d55fc3e75153bc"
    sha256 cellar: :any_skip_relocation, monterey:       "2de5b64b2d4edd3a425b504c8539f88f3aa49bc70a7bcbf1c711320e9cf68b7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f02360b67ac3f9cccf3e4b4f8676feb121722beb8581e2583aad33b770aab8bf"
    sha256 cellar: :any_skip_relocation, catalina:       "9289ece6193c41c9050dfba6c339aa612dc99520136bb96931232e4dd0e31328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e41f1732ea3bd96ed7ce7e949099a99fbf96d6aa1ff7b4bcb9651ad6ef1db56"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -extldflags '-static'", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"jf", "completion", "bash")
    (bash_completion/"jf").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"jf", "completion", "zsh")
    (zsh_completion/"_jf").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"jf", "completion", "fish")
    (fish_completion/"jf.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
