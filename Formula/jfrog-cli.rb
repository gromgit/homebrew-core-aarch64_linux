class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.21.2.tar.gz"
  sha256 "c03a6e8929c02cbd3fe3bfdfabacdf6bd48840b4d9842cf7214ceeea1cdd04a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "717955580913c234216492b8d9452eed18a6c2ca5f31de0624f6e3f0b8d711cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57ec775e9c389bf6cab8000150e3889dd4e6f9d27951889344d972708725bdf9"
    sha256 cellar: :any_skip_relocation, monterey:       "bd7b5abd25148c7f1cfd042d40891d74eb7b300b20d2046913899dbcf140152f"
    sha256 cellar: :any_skip_relocation, big_sur:        "714fb66926ac75bfa7c74e3fbede87059e9eb0dba74c5d561348519840ca76aa"
    sha256 cellar: :any_skip_relocation, catalina:       "95ea6e957fcfa6f3aeb71a1518bad1221eaae108bf5207f8c33a7a415131ecbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdb6e0a8e6c91446de3922de13d3d6250ac73954aa1c6358f377f2f9dbc55579"
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
