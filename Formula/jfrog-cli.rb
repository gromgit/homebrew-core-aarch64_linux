class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.16.4.tar.gz"
  sha256 "b713aed29a145fdd164f549f748d27dd699ac51c01ad478c3d0c1ef6acffd403"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e6b89a565485a4a5b8fb2b676f0982176996ff32999893807493ee5d55a8242"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62cdf2f09e8aad04d4aacbf2c375434de3921e3b1a2cf7e252456e5bebf02e1a"
    sha256 cellar: :any_skip_relocation, monterey:       "79af3d13ce4768deaad1e2ca1733b4ed49f06e45dee3d7a6e878272f9454d9d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "78851f2552d9749205d11fedb1ed127c4cf36e565113cd13a3b2e484db583b13"
    sha256 cellar: :any_skip_relocation, catalina:       "79f04add3403a950bcf72f27c71a4614181440345828bd72b8a86205a852cc79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ec7650257b4a7e8231124d63bba6780c4a0b3401fb2f331edf2e87286ed06e7"
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
