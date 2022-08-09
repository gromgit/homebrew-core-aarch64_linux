class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.24.1.tar.gz"
  sha256 "a2f02774ff045157810eaa56d48cbe72ffb54823953759ffaada9cf7e2399eca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0001b405ac7610209bec5b959c12b7bddde7f8e8dff6b992c536721625ca81ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "444311cdc082e710c0b14818c6f131134dff5aa65d9adde0082dc5a65ed56982"
    sha256 cellar: :any_skip_relocation, monterey:       "d075230badd2387c138e580e960d09fba9ef2a602ea982f318e2a1f0a69484e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a6a13488396ac296d5510018e15fff20f797bb12c219d0da24b063a7f47ec80"
    sha256 cellar: :any_skip_relocation, catalina:       "493dc2e66afaa93ec8202499ae8cc004eb0dc65e950c01309c6d68d6513eef31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f3071f087ea5192d8e78b5a114ab3f98f7b3852a84f9dfa756694f8649ad9a3"
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
