class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "b1cd153197e3c03b20d14cb9023db484b6fe9faa86982633c8ef138cb0d75332"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31840bcb6a2a4a7682c2a44aed0a9a99b38f8b4bd06497a86bfb176837823bcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0c53cdfcfbcdfcdf19ed1c7e60f5ec8327abe6c85ed0952f54352986da67635"
    sha256 cellar: :any_skip_relocation, monterey:       "a20825ebf1297a4aa903c044d2225d5bd5f7ee7acf317e0834426ed8850921c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "19b040a14a455e265e0d21467a56dd17617e9fd1ae674e2c9ac8465d7ee18b93"
    sha256 cellar: :any_skip_relocation, catalina:       "6cc8ec998c4a3f21353362f488a2c3c2a555509dfc89f7333b9e8b679cb42c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b8fd800f64888b96266badfa6904dfd02b9381ac05683f5747eb43ee45df3da"
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
