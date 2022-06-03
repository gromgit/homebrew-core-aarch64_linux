class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.8.7.tar.gz"
  sha256 "b99b8613f3482707d35e866c23ca8f39ad0fa3bda6613568c087766a050c20a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8e95c49ef6bc8e1c6674a793aa3e5bef3763812e357e151ded586a54dcc09af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccd8e23ec95aaca1d28d3deede84ec0a9515ad3c896c8cbe6830159c715d178b"
    sha256 cellar: :any_skip_relocation, monterey:       "6dc4dc4d870cf79af802a5decea05a8bd254c1418d43dd13968dff8fd4bb2f2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a8b873cafd896e1002d2041aac246c493cf840cc457a90699edb703788f36dd"
    sha256 cellar: :any_skip_relocation, catalina:       "88b9d6c4cbf835401f8790d58e8faadd7bc52f0f115baa68bdb2e7f345c85646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e00a239a5ebcc1642caecc0d4f8b20831d5df166ddcf392d2eaf7e8dcd7fd3ae"
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
