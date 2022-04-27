class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.8.3.tar.gz"
  sha256 "3e1d680ff36ba3c24ff120f33e04a22da593cd8d172b2d9244716c37409226f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40654e132165a5a8c1c3953f62f30139e8a02257073737eb8b586ea83695cbf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb16f3ae9784c93d9ac912d02facfd491562439990450c3754af5a75af5a14ab"
    sha256 cellar: :any_skip_relocation, monterey:       "422dbcedf64ec2cbec423e1c9782421d6f87f5937173497312a9c5ca44d3cb91"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9d89695c4114d9729784cd85cf47dfde02e29ce39c3911a33ba9057a56e5afb"
    sha256 cellar: :any_skip_relocation, catalina:       "f2157d4efbbd3a57b4e048b90d68864b78744a56803d1e0dbad314792ac0d059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35a51b239c317a71016cf8c49e7ee62e08980be9f759adf454ba920f6a4f0c78"
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
