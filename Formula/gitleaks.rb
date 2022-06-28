class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.8.10.tar.gz"
  sha256 "36ef7b6a062c9692a4a84c4f747c3044c81d4d6402441f1a61d3bac339339882"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6270b1ad8c2b226b632a8b6b23993afc4ec0cb6919610bee0e4221d6c52bc7b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56f932e040168fede98f1d03b2e2eb56dea26ac4a5613f29869aeaa2998392f0"
    sha256 cellar: :any_skip_relocation, monterey:       "46b252b313c0fe4fb93d718709e57864769aa539e2434edba7c44393d32400a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "474661cf333f4714a6a15a40228fc631b00965961c3ff165e20b9bf255439a63"
    sha256 cellar: :any_skip_relocation, catalina:       "c083774fc3332ee1312fb606850fbe39d458ef937b9e8403b9739dd707196627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f91b256e511c6337181acb094f10adcf6dd18687b5de33b6be57aea99ab30d62"
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
