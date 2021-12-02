class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.0.6.tar.gz"
  sha256 "1d932828cc7758a775e413abfe20d4f20d48b58fccbfbdb688abfeec70bbb7bc"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05d06b9b3eee4cdf41091b860a48d5c56a7bd0495c0c0f39a14f58a91df30299"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cf097178cdb672a29e5b79aebc49c852369607502ba7b44ceac92e7a2dc0dbb"
    sha256 cellar: :any_skip_relocation, monterey:       "b4d6d9b56b1321c918d4cd1129fb2ac7293b6c39e2c21fff89d54b82431d305e"
    sha256 cellar: :any_skip_relocation, big_sur:        "14e88ccd61cbdacd9e647e1d86ecc0a27742b2b49ff0f2199ac393e44a0bd13a"
    sha256 cellar: :any_skip_relocation, catalina:       "8fd721475dd1476c8385af4305de3fb88a3894978f644aed755076288fa7b597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4323ba0ff5a688e0f9066e58f561a5bd3f8afcc1f87a20a8320bdfd0f505e954"
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
