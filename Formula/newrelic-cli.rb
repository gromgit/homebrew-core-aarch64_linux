class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.28.13.tar.gz"
  sha256 "e6b8053a8d6dfaab3701a10c2a5b209cf53e2e13a5f7943806ba5a41a52041cd"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "378fb47e92f7701a091cd656917a0234e1e9f5bd3a1f2ea4f0e6884e963399f9"
    sha256 cellar: :any_skip_relocation, big_sur:       "f3b5dd0db482591fb3e7a2ac178df28b8d7a9de525201f4b66f5fe225d91f995"
    sha256 cellar: :any_skip_relocation, catalina:      "920d58a0e40564b740351da82d1f4eb0cbfd5962118d1fd654f967c92ddd5fd6"
    sha256 cellar: :any_skip_relocation, mojave:        "f1548a6597327766439e7a29b2f929b55895bf0ae998f7f7b395eae6e7c9d0f1"
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
