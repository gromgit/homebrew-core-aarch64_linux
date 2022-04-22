class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.8.1.tar.gz"
  sha256 "99ae0a14f6cd339b61ef4cac022787dbdfa2ce162007d3be75645f461734f3d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b151da656e61bc7862296389cee2963d1242c5a8d3a54b30c199c2925c3c541"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "540b30b71e7bd34cb85def02f47cd7909465b4b536d59a764122ce71fe246814"
    sha256 cellar: :any_skip_relocation, monterey:       "812911f3b28617af637198d4299c183b7b816a70f7a0d425c446fa3acec99c60"
    sha256 cellar: :any_skip_relocation, big_sur:        "870db3af02a70a0566ac1543934a64e7214fb81be3d2cd905c0ae47f9fee3929"
    sha256 cellar: :any_skip_relocation, catalina:       "434f7993e9f3f3222f2376f8f0a67814a739c1ce27870ea4d2206602e680bc9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "020a70a8433d898f2eb2a44c9a9f068a7a3206195551b84724761bad90cfd5bc"
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
