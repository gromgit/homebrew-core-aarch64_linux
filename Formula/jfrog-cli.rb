class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "2a8c6418a691cd70cd38b76a8096f5daa89388d5978c444b69b3ea3d702ff70f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0ef6c4189e183517cfe13ae9f47d281f1f8d3e4c2b0e0726e30605f90790746"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45e086c09b550453bc69bfd705acc47113604fa4c505eea62d2a38cd2ac7b9a3"
    sha256 cellar: :any_skip_relocation, monterey:       "dc7f93bd6a240a9dff6d1a464fe6572bdda737f9dee35db09a0829eb9b212da5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2045acd9df22c8ad33d5fb949d97acc0ae94d0954518b32035bb5d0bed491f0"
    sha256 cellar: :any_skip_relocation, catalina:       "56410f88f0cd479923ee9855ef654c80fa39ade5bd2853e605b85e395b8301c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a92192a62bfb4792c851033407f4e03e04d40f812f496ec21b8eece23cb422e5"
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
