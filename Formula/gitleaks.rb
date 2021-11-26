class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.0.4.tar.gz"
  sha256 "a9b9166fe7cbdb6f9a66d2b53476f56b46cef013dec0a0c30fa8379b9ba1207c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba2bcef5eae3404da15ff41f30a2dc52c4eee41ef9c367c4a4a874d605135fbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aca635c8307128ff08a26e2fa2b8ba7796a4b4ef343f4a2e4a73c804a483d469"
    sha256 cellar: :any_skip_relocation, monterey:       "90c9963f5792cde536c1aebd7a9ae1793d82da193905482b0e463893390a97f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9cad0f05796c8c94032a590b2f0b8b5852e9d743ddb289b598121e7fd28184c"
    sha256 cellar: :any_skip_relocation, catalina:       "8e5e3c54cafe28b31d2c2cefe3a4641d16b0b556d67f776def2ef52030e62780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41613d65eba50156c1c7895b05ee972b2040828abb01aeeb2ef263e60d10e834"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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
