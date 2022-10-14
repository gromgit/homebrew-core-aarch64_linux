class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.15.0.tar.gz"
  sha256 "a2fddce19f531b2adb679d1f353ab312b44b36dd4aa29be2b83b6d99da64e14a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fda78159b273b3e4f39cf705ba9886a68d50dbdbe2beefb26fe93717c061684e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ef2927af8a46395f72c4400a64951b22251f27e3cff0e6b42945db23432192c"
    sha256 cellar: :any_skip_relocation, monterey:       "9f45dd4067188ef64590aebe3aa7da27624c4e6efe40f036aa448e6fa9bab3a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "58a9c458e7235bb964d1fa431d9da9b0c1053ccd5c967e01f1b26b464448251f"
    sha256 cellar: :any_skip_relocation, catalina:       "a7714bae4906169adc5cc233b87d1a16b55098c0def71621cb9eded78543f479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1390ca29889ff69d103f65b05383c1bfec58cf3366042e0ae4c05e778d5e0bc9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gitleaks", "completion")
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
