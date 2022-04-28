class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.16.2.tar.gz"
  sha256 "9c4da58c688d5d680602c4ac12505ac7a4bbaaffe1d7dc3a788ea08a087aa29f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6cae12fc152657435e597e578bfd1bb504679dd7ca0280910b1bdb4441e484a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "992a22d0b20fd16d375d6c2348e3446b18e092ca3d47370fd3bd4d700f0158a7"
    sha256 cellar: :any_skip_relocation, monterey:       "f65fbd0c1c219dbf0b71bc118b1caf02e7b6c9eae37b5c142652cfb0bfd1fd46"
    sha256 cellar: :any_skip_relocation, big_sur:        "57eda6198033e44ee786cc0d9217b6581178f52a276bf8bdc9173e46161d3318"
    sha256 cellar: :any_skip_relocation, catalina:       "fa7865f73bd5de17609d3d0c934512a38317481d50614fe5b7d0efa31f1bdc3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38cd6060f992d5601fadad8b3e9900d3595fe302cf326bc40c133b0855fffe99"
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
