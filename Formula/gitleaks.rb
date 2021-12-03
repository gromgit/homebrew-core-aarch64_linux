class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.1.0.tar.gz"
  sha256 "a3eb94cafcbf08752856c49403e945fdb118b94b6ab3167dca2edf354cb4ecb5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d76f21b2c6cdbdc7b9e2b3e48466f31617ae48f4c9033a1ba47e999699f6e2e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99a8f8a833c88d7ce9191afbb85de025fae783d894399bcd6009281f5f0fecca"
    sha256 cellar: :any_skip_relocation, monterey:       "37774e8da99629d785a792d7852066346d750e629ff81ae32caff4f3cada690b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9459a7b4067c40180371a9b8a9822c0575197b5abc7252a30ffcb6d45b591987"
    sha256 cellar: :any_skip_relocation, catalina:       "08d996520bc921071faeb17776d65667ae6ce947bb2eb22fc554c6c5989537ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff4edd8831d6c0bf85d794096e40d667aa4afd9c3469e1275ae2a6e0c3a5eb26"
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
