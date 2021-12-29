class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.2.5.tar.gz"
  sha256 "016e6ac7dc2400a99d0d2e830fcb02e8c4801d6a71ce4865e6b800e1aba4296b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4412715c04255cfe59b9bf5a4a4c09e0e0ff504792ec1fd0c40042be1ea69b9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e83cb85d8b95c4e20738bb2b156f6327eb7c2a2bd2127bf4a951520abb26e859"
    sha256 cellar: :any_skip_relocation, monterey:       "aed8374bdb23684a00839accc1d0e3fe991aade6a75e3c06052e5461cd28b941"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a94c093157e25d9fa0276d4093b2b26d617b934bb6a83da2f6af120a02bbbd3"
    sha256 cellar: :any_skip_relocation, catalina:       "6349477873a0ee892ac05aa22d2a8d7dd57e5c2d48d44cbe69e677479ced705a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bf0c07fd2e1cedd401264fd5cdf8e85e7f8b9b816bedfe743e405d0689aeef1"
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
