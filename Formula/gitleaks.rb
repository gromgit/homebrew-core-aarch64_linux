class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.9.0.tar.gz"
  sha256 "b3644002fb431443a97509c26d8bc1ad0eda4d38c6a638f0a6f3d936e42da332"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "febe51676526287037d70c7f44f5276d6a62333dc32b3510f77fbce284acecf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d80c45192ada33d83b5246b8d1d870be8e7cf587f6e5148f3023f68f43efa8a1"
    sha256 cellar: :any_skip_relocation, monterey:       "886bd197470cd8e27b1b74075be620d6fbec4ee58700434e01a6b6eefc2be9da"
    sha256 cellar: :any_skip_relocation, big_sur:        "93cb04a442bd17725e565ab8cd60e6a83c829b75c410b4ad9bb86dfc39a0c350"
    sha256 cellar: :any_skip_relocation, catalina:       "9391c27bc18dad3b309ef36038f2d9c6a5436446fb177b8ac3128265c7f68427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99447704c48bf2192f66bc7f6bfebae774564c4f1db96867946a0664f031806e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"gitleaks", "completion", "bash")
    (bash_completion/"gitleaks").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"gitleaks", "completion", "zsh")
    (zsh_completion/"_gitleaks").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"gitleaks", "completion", "fish")
    (fish_completion/"gitleaks.fish").write fish_output
  end

  test do
    (testpath/"README").write "ghp_deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
