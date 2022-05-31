class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "f03faf282899cdb7773e7f4ce9921f67040078f592b8e4c275ac6d4917d32eb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcdceb22cc026fd206440789af522ddd6551bec1ed2b07cdc5ca7a21ad2178e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0eca9052c7556090242a360864f2563a38fdcf673b853cca1a36fffd6203a249"
    sha256 cellar: :any_skip_relocation, monterey:       "5f987f3255046789885aa1747e3f3d218f4497a0139cecf051a1b01bea0850c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "46a0ad726b1dbb5fdb240b4d14ac12b5539b3b9dd61b0ea67411626019963908"
    sha256 cellar: :any_skip_relocation, catalina:       "b8a060ca93b6f0952f1db2124f502fb4c1f01269ca62c0b8238b23867b593438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b84e9e240a9660e811d393756a707e2215bd39bd1482a56365796fe98460526e"
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
