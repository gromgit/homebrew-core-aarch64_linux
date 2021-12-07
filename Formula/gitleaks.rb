class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.1.1.tar.gz"
  sha256 "5fb39487eefb5baf7ab5fa1a54c1a5ea919c7dcb175e80d77e1f530f81dc3396"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab75c5c4a6a2732140cdb956b4b65bd6f8eb3b8cf4f5ca384226a7aa09ed3248"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a7853851e840e5b9e523599b0b5cdd15125c4c58d1881d262be3d37f90d87c2"
    sha256 cellar: :any_skip_relocation, monterey:       "638221af8ade60a71cd786bb1ac754b122d8a3084d6875f24136e5053926eeee"
    sha256 cellar: :any_skip_relocation, big_sur:        "83eecdd35726cebacd45c8044f7053609fe9f4c788cfb71a498a638986f977b9"
    sha256 cellar: :any_skip_relocation, catalina:       "4604831f19b1ce6ffdf204bfeed121bef72746b901d20287b6458c8976e2701a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac6733aa948a44438cf86b363ddc71e6dc473027062973e1cb72b9f08ee18bf9"
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
