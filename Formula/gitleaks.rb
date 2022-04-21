class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.7.2.tar.gz"
  sha256 "6cc457af856950752d2fee747e95cda0e2d3ed4babb826687dd5806888153b8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7a4f232d3384451a99c0a1f425e2e7f1b96a3ac291cf0eba089d9a8ba0bfe8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70d21da381efebd86c0128df664f3d9f67d2afb3f933e6f964cda8e8d2033354"
    sha256 cellar: :any_skip_relocation, monterey:       "659feab1b748984a9364fbbecf40e229448c27a6368ba775321ae9e8b384b69c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cb8acf9991ef119de3db9e319bbdc474d77861c2eac79dd015be709e3de12e4"
    sha256 cellar: :any_skip_relocation, catalina:       "0022ffcdba1c72cb6f0355d0e81f018b01d58efe388d897aa50a15a89ad13cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f4fd45c15c1810823545dcaf6c43b3bfee0707e398e84d9832417b81e712baf"
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
