class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.29.1.tar.gz"
  sha256 "8e54f6492548761df61d2b29a19f389b7cbd27be6ab576f0e69d0a080e849d84"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfa43d138b1cba98ae28d47f183fc97010a81db6aa7d69e3f4b353059aea4e56"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd82541eeea87b9a5ec92befc3ab4319d9f73bd79fbd4ae481f471761b23c48b"
    sha256 cellar: :any_skip_relocation, catalina:      "70a308f8a3f40f4a5fea53a848f61dc3ee32742b0d87ea0713b7e7c61d17c3a7"
    sha256 cellar: :any_skip_relocation, mojave:        "70bee4afe4bb06169b4926992eba45d2dc76d84feaf66730b261439cb62b2bd1"
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
