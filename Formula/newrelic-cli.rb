class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.28.4.tar.gz"
  sha256 "d8bf8e3a16e57c42b6f93076472eb6287d0b8d7c551c0400faa527a1a84780c6"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8799b694b41edf8ecda735654de6f9a852644de9325443148d7d2f05e3bcb9a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc1672cb7ff040a5ef2760f9f8ccb4d20ea1701ef4427b43e55a3fe4ee9f9760"
    sha256 cellar: :any_skip_relocation, catalina:      "6f171fa96d5367a4d262977cba6b199def9e7058958d45c45facb88bee5b66f4"
    sha256 cellar: :any_skip_relocation, mojave:        "07ce870006f81cae98b9c20b49b6c4536763b4418d3812d5b6dcbe0ce0ae1510"
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
