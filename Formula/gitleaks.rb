class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.8.6.tar.gz"
  sha256 "2fddff2b940324c34e52709f9d2e6dc00471f301d4c8e2b4317c3b21103e251f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b894a8c9f9a887ef2f01cdbe61e0daa9332c1f1a889527a8fe27b4264011c42f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ee9d0d896215afa8aecc9eaef480ec37c35c6321d2c5b46f62d98b3eec9e807"
    sha256 cellar: :any_skip_relocation, monterey:       "b7bbc4e89012f266e0601e77e8d8821cfc9a5c510a0973638dd78cf92be0d678"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6ba54565fa2f155189e4d7a241e44bd93d19c79d149aeb36665f0dc80dc61bb"
    sha256 cellar: :any_skip_relocation, catalina:       "e5bfa4ab89d65d16a8505bcb214081cca562cc3e6c46006d4d19a855a275f6ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14879ef8705b375131c9b25a188c2ecf90c28bf8355dacbd8d1b7905dbe61a5d"
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
