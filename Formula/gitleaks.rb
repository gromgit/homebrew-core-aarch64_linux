class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.8.12.tar.gz"
  sha256 "94b87cfbfe91bdad48f554acfb8ce3f50f994e729c17e8087140c004ff8c22f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a10df05f4d91a8da67ec81b436564992daae80f80e7d741fd775c54b2de98025"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6669518af0718e86708668770d98489b7425aea9ab9c4c5beaef537d781cdf6"
    sha256 cellar: :any_skip_relocation, monterey:       "0a21060a5bd994339b0efe279ad404396959c5557a3f6a3ae83fdb0bd107f84f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d85278548a6bf6ed4eb5a79dc9c98ebfec3fafd78425b5d01936e2767dd467a9"
    sha256 cellar: :any_skip_relocation, catalina:       "6f91badf79def15cbd72529a6fb500685f842fc7b35e307723178d6b32b78271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8555bdf88135c588d27970e6f23151663422fc8ae13d85c9f7c442cd0c906770"
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
