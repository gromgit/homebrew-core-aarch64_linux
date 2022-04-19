class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.7.1.tar.gz"
  sha256 "e7bd041e46c496c1f69ad49158c6d085fc9f0081556c628ad14e40fadbfd166b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b20b6ec0bb271bbf9944baed451d385009ed9042d997c0aab7440b27621401de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a2cf94f0e6dad073eb91dd9374aff383deb7fafca52091819e4c1a33d500714"
    sha256 cellar: :any_skip_relocation, monterey:       "f7a847c6cfd2e9cb753f503b0f35b831997f53079a3b5047e7a2e2f876e2b0f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "982401578f8c89be85cb56951d0cd1f222b8152b85b5c515ad8eb64852cc2d4b"
    sha256 cellar: :any_skip_relocation, catalina:       "75f556ed3ad840f709cd439e75b0ffbe61812a7e76173c8e0428a7fc1a29de57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25bc44490157f24c62d9b704974cf926705f1d66d4093cdfc5682850672309bf"
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
