class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.19.0.tar.gz"
  sha256 "bd08d065a504a3057bccad845826d26eb16566bec5ef0f816bc18c1103edcb72"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a246f10ab9c0eee2b27855ee49aaa3e089cbf233bad33269861b11fce5a1acec"
    sha256 cellar: :any_skip_relocation, big_sur:       "128aa082b5fbd9558122894788d5717bed6531bce48c7abd2f82aa726e25e6e3"
    sha256 cellar: :any_skip_relocation, catalina:      "6820d45b508c43cb0b86fa8aa254e07afe2a932193cc632a42e6dff0df961c72"
    sha256 cellar: :any_skip_relocation, mojave:        "e28b74d868e34892a8428caea1568382b63c4fea9fad6b68b9711bba770e80ca"
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
