class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.0.0.tar.gz"
  sha256 "6643ad25a5f5b42df0835b770848aef1993d770f09cfc9a1e6bcadcf71d7a2cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecfff23673c7d59ef5ceecb0c1ecf665a0e6b12eadffe6a82796d590e7eb74ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72bb30a03286fe3a2f5ecd42af4849bf08d1a1b9cdf079f34a5e10694a6e682f"
    sha256 cellar: :any_skip_relocation, monterey:       "c305a621a218b390b8286c0262718fe63193860bc5798ba8e6320b95990c8483"
    sha256 cellar: :any_skip_relocation, big_sur:        "500a8f4956d9e8cad5655d82fa5c9071a1a95af04234062c88319db42553e11d"
    sha256 cellar: :any_skip_relocation, catalina:       "f2308e35b757c7072ca19ecc46fb160429e24d0598f0da1a18044b6b2df4950a"
    sha256 cellar: :any_skip_relocation, mojave:         "e260acbf8153b0abbc343163b03733c2407f7203ea0d13ed1c0c153a16195303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12defc2174e60cfc8ec0760c7cd142eaae8f4361aec3a98b3792bc98469277ca"
  end

  depends_on "go" => :build
  uses_from_macos "git", since: :big_sur # git 2.27+

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
