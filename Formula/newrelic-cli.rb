class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.52.8.tar.gz"
  sha256 "6f313a4012392bedab3a3f8b8a3410ec4405a516adecddc8037784aa2e38ea1a"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9445c5b4cd402807ca456c21212a86d21f18f36672fa3f23574acc91f875b43a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bb2cdb42a1d72c74d0c31a278b8ed8f35b1254f1456057694f2ea163b39b1ba"
    sha256 cellar: :any_skip_relocation, monterey:       "abd32eb83ef23e6a26d29e921b4d1ab4a6d4c080ad2ed4f2becd0051669f268e"
    sha256 cellar: :any_skip_relocation, big_sur:        "770a251a7f84bbfc7d7b329d2dfa8057b762278fac9e5f0ddff5521678491524"
    sha256 cellar: :any_skip_relocation, catalina:       "5b287e8c63023c2732438ac010a13ed0c17b059ddf3b7906ac4f0a23b5668928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "001bcede80dd17f044a23c7efefdb8a7b5977fabb4ba77c61c7c08f99aeab41a"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "fish")
    (fish_completion/"newrelic.fish").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
