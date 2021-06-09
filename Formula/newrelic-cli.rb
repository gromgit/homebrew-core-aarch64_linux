class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.28.2.tar.gz"
  sha256 "21c2a7f4ab18556b5a5bcb742013e06f8ae0150297dd09137423434d3eda68fd"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0ccf935c5910a656ace08881108567e92fd6f5b0b42efb61148155f1e3104710"
    sha256 cellar: :any_skip_relocation, big_sur:       "d2d7b7a25d1018736fc99ee2de0598aa3c30017d4e598c0cbf153be59b7af494"
    sha256 cellar: :any_skip_relocation, catalina:      "54b0e6421982c4b716fe1444042e8a5b12a6efb08aaa7e605ce3cc3e558964ed"
    sha256 cellar: :any_skip_relocation, mojave:        "a325741c43825b5bf0c7f26559e8c4104c8187b55e21467848fac29fad18c0de"
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
