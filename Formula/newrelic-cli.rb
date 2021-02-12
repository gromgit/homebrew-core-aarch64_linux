class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.24.tar.gz"
  sha256 "e9da1ee4fcd49626415732bd6ae04ceccc3957c8eee26d35854d9987a3519be7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c3b2f6ea190960db2d09c1b030e315596ad0964f229063b59633fe66744d314"
    sha256 cellar: :any_skip_relocation, big_sur:       "30dedc46ce70cec41e90585ac923e869b02551836b21a565260c575d5df7113a"
    sha256 cellar: :any_skip_relocation, catalina:      "b05ef10ecc3c30bd01ec213f76f2a9ef5f25858f3e11a89a597264b2026f5867"
    sha256 cellar: :any_skip_relocation, mojave:        "40459604e6b3e66079e683b6bd1f726f24a6b0a23f455d2cb237d0164908b2d3"
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
