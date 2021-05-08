class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.25.0.tar.gz"
  sha256 "ef20b8240ed4943806fe0394ef8f43f18df189bb7d044f68498e1e7ef42f5373"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e8c566f54a1b42d69f403995e143f0bb5266c2806005cfce2c0bdf93780c6456"
    sha256 cellar: :any_skip_relocation, big_sur:       "d95cfdd74101849a5908d15860a9640fcb90772502e18dbbf59d1a5e5faa9adb"
    sha256 cellar: :any_skip_relocation, catalina:      "0590329ff78d2906e9f0b349591da25d2e4c331e10a1d370327bb1b181448495"
    sha256 cellar: :any_skip_relocation, mojave:        "df403b760d82735c7403ac5911a60d787078b2f662922f681b0e2236fea35f91"
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
