class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.21.4.tar.gz"
  sha256 "af3be1891823c1bedc2326977891ee65ce7e97e7e27034f32a7a056de488619a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa046105c5266a6098ba2a4db952763fce464e1d699d8114c0cda0aca7033c4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "766346ef6ed223368dc508cffe3a0578f460409e9a96a0f1b76708a25671b0d5"
    sha256 cellar: :any_skip_relocation, monterey:       "46112d7158086e11b2a6a62ffe32a00de45907c15ca21038bf1a8bffe35cb780"
    sha256 cellar: :any_skip_relocation, big_sur:        "99067edc45e1266de0c0c72cc2bb062b1c4ebe985c69196a6f7c35edc6d0116d"
    sha256 cellar: :any_skip_relocation, catalina:       "3e5ec8255e58f2f983764b5be93f6a1b09e80685e1a560bf56ee9cb9715e207c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0793efa20b7313572e978c3c64ee4cfc82a03442f40d57249a1c1945844e718"
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
