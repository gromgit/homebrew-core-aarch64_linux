class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.29.0.tar.gz"
  sha256 "6e8c1c3213ae63c299627bd1e952de2a29967c9d846f91111bf6dbd09acca0a5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a15f5c021531fba764191e2dc8fca00fc603e54bc1efcc8f5e1c9f4fd5dae43f"
    sha256 cellar: :any_skip_relocation, big_sur:       "2a8b9981768e5150f2fecf1a3a800ea47b76b0cef8b0e83bd9f172b6d1a42ee7"
    sha256 cellar: :any_skip_relocation, catalina:      "c57d1b978627d06dd14bf2444a19df384626854a8aefa2c1a44ffc54d99a3586"
    sha256 cellar: :any_skip_relocation, mojave:        "60f876318c55b32b8477856423579e0eb4121beb176147c15df0e90717ee59cb"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    assert_match "pluginDir", shell_output("#{bin}/newrelic config list")
    assert_match "logLevel", shell_output("#{bin}/newrelic config list")
    assert_match "sendUsageData", shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
