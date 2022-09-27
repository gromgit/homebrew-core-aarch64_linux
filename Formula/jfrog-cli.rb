class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.26.2.tar.gz"
  sha256 "00a0cf405360ec9c75b17c77ca255cd21a5ad5c4340bc1401a7777c2be164b42"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6911e5ff469d6b9a48fd42c2d44e93deb206eab5190af84bb8c10451f8b8abb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56d735da9342a83cf4d029c44f74dcf210908145de154efdbc144ed6b9e0443e"
    sha256 cellar: :any_skip_relocation, monterey:       "63ff12401fd589774c21307dbbc3e8882105a6491a5887a69a5eb8d0058316b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "26d307ac6b945b3d2c2d76dda9829aaa4110d964d6d685018b08a96e7af13a84"
    sha256 cellar: :any_skip_relocation, catalina:       "b55479524110d5f3a4e4fade87e7cbda8fbec4f802594eb3ea34bdaebcb2cad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cad926e806584c2afd3b755d1cd356daf225d6493a11e96ffe7931d537fe523c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -extldflags '-static'", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
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
