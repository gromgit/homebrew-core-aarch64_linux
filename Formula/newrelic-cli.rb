class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.27.4.tar.gz"
  sha256 "7fb1a0553d5d0ecb25a46d8977e00258a5f4c50673b282dfbaa1753856f6fbc8"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a33b3eeb4bd8a75030ad8a91096d8d9dc45fcb0f9fb78d27b219ec874708f581"
    sha256 cellar: :any_skip_relocation, big_sur:       "79d5116df4b93681c1bf6eb38e2c289686a165e431cbc66f04bd566207b710df"
    sha256 cellar: :any_skip_relocation, catalina:      "2d96dbe8b0f941c5343fdefe50518c5a44fc62cf1090cfc9325a339fc33ab373"
    sha256 cellar: :any_skip_relocation, mojave:        "6f369573f9450add16374c0b21b7d3237a86a68d7e224e24f565ce32dcc5098d"
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
