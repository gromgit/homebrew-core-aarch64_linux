class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.18.0.tar.gz"
  sha256 "0e83072ad483ccd6bcb76e0ada327dfce65e1770c7841aaa82245dc6e00d413e"
  license "MIT"
  head "https://github.com/profclems/glab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "46477cff1e24166244b55ded06c09a663bf73b00c5f98b896805f19e39434156"
    sha256 cellar: :any_skip_relocation, big_sur:       "00a723ef606c69a93706e30dcbd49503a20e2ee943e16d7a01990e12b638da92"
    sha256 cellar: :any_skip_relocation, catalina:      "00a723ef606c69a93706e30dcbd49503a20e2ee943e16d7a01990e12b638da92"
    sha256 cellar: :any_skip_relocation, mojave:        "00a723ef606c69a93706e30dcbd49503a20e2ee943e16d7a01990e12b638da92"
  end

  depends_on "go" => :build

  def install
    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    (bash_completion/"glab").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=bash")
    (zsh_completion/"_glab").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=zsh")
    (fish_completion/"glab.fish").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=fish")
  end

  test do
    system "git", "clone", "https://gitlab.com/profclems/test.git"
    cd "test" do
      assert_match "Clement Sam", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
