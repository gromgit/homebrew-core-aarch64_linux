class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "c5e0bd23bdba940e2196ed492d1468e5a674650020b5d5bacd9d5c43976e5ae0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a5a6198559db6b2c99cb52eca525bc046b1637dac3fe7d79cd9f0ba128478d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "101178454abf88ab452eb0fcfdeb936c7ef6d45513f3b5b630ad0ebf679b9f86"
    sha256 cellar: :any_skip_relocation, monterey:       "59343ce15c28bda06a2e3f9da570ffa1a19c2fb3164c4ed940dcdb82ce0b3805"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a8f38cc274475500ad45393f32a4c663c660c4a808dba790aab83a3d70e4a73"
    sha256 cellar: :any_skip_relocation, catalina:       "ceac043a9b37320d69607b08a480a36143ff85b33965f0f71c1ef34d15e701be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79444101574e6d0b9d73ce874e6415fd0b1c6b17b00ea8af4dda8acba6b436f3"
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
