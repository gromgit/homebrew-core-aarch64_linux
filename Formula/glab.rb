class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.11.1.tar.gz"
  sha256 "0760db3187b7c488925464c87a88b10a4d60018796ac1a877e41d1eea4ac67ae"
  license "MIT"
  head "https://github.com/profclems/glab.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23c8c7338b05a82257c762ab05431c04d96336f06afb60c5275b5e86104c25fa" => :catalina
    sha256 "17421f91e7f700a7ceb45ff78c9cf49038fe635388c88f67719c704ef46c14b5" => :mojave
    sha256 "3c5b40d0ae4cbb093ae82164c4ad7e0fa1014a1432f6bbb0727f0349e9cdad59" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"glab", "completion", "bash")
    (bash_completion/"glab").write output
    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"glab", "completion", "zsh")
    (zsh_completion/"_glab").write output
    output = Utils.safe_popen_read({ "SHELL" => "fish" }, bin/"glab", "completion", "fish")
    (fish_completion/"glab.fish").write output
  end

  test do
    system "git", "clone", "https://gitlab.com/profclems/test.git"
    cd "test" do
      assert_match "Clement Sam", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
