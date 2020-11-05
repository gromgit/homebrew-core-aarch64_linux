class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.16.0.tar.gz"
  sha256 "09e40ba9a607ddce918875a3ee7e7c3e5fd990037cd1fda80a9baa19d8ed6c8b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1880f53afe083f9e87411cec695a9eddb6589a2593aeaf4442556585340fe38" => :catalina
    sha256 "6787fc743c14cb6d6e3ebbe014a05e10120e99b658e98e4442203c69a98fc81f" => :mojave
    sha256 "c07aa7ab77ce69e728e81fd501cd681559e960691d6a8197dbe89383ce6cc4b2" => :high_sierra
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
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
