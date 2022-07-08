class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "ef081eb8be123c03c881a0ecaa4141ee372f50588da8904a5c4306d89f412be7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8c700ed5e8e590f7dd0e29715abc958e863d13fad45e184538b6239f22d0373"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbc22063602ad12cdf87b59b9dc72c10a2bc4f00ad9641b379ddea1e24bfe8bb"
    sha256 cellar: :any_skip_relocation, monterey:       "0f73a25992f1a38c0e3207eb339ff714737c33975c5608f0a5e86412a42f7dd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "89b1fe0294fce01dd7f68756d17bfbacb8662b449514bd5df6ec0f3410cbb3e7"
    sha256 cellar: :any_skip_relocation, catalina:       "a9c98bedfcdfc3dc5629f7aa42bfdb397d5b4a8a3855497a83bc9ffd67604c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5034a1728dc42e54050a23c39ddc71f1ea04c17cfa435f5cef7d632524449d18"
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
