class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.27.0.tar.gz"
  sha256 "e702158c04aafc5e1ff8a5473bf18a16540e2065245490fdf963804808c54cc6"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "76e7f8b8c9928ba0f7e8a7025ef77f670c3374753f519f7f579ba6acf014acb9"
    sha256 cellar: :any_skip_relocation, big_sur:       "b59d149482db8469f34dba9a94c7375f51551e2ff1cda712aa8ac5fefee83a80"
    sha256 cellar: :any_skip_relocation, catalina:      "9d29ac38d68f446a58931de795259b2f1b9e11e4e2b9f80d51a5f4c6dcf070fd"
    sha256 cellar: :any_skip_relocation, mojave:        "66248d724523de29889a6846096a70bf847bfb919399f1ffb0de634f87187752"
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
