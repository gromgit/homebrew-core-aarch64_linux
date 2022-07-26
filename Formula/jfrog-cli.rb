class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.21.5.tar.gz"
  sha256 "191a4ab27275ea0a10a06236e4e31092b7dfefa0000e472aef12f2bc8297abe1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ea2433c07934e06dadeb2e7673dff7847502917c53d3c362b30b7e2fca9826d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd56d7483b3eca189358f298e055d9df2c991d0620ae64cb6167189eb35555cb"
    sha256 cellar: :any_skip_relocation, monterey:       "b287a8dcc5fd5b656ba39c5333a45b4cbe43392e50a60755e6596681cb346880"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7551dc1c8adbdf199d58e5854828cfefcb9cedad72a6936fb390fdb371a6869"
    sha256 cellar: :any_skip_relocation, catalina:       "62761b56489d5ab87a08b6a1f442ced965f1f36f72ccf8a97b1edec9c43c64a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee848562da9066431ccc44ee3b27c968014ba7e513e5bdd7434858895da03ca3"
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
