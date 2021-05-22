class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.27.3.tar.gz"
  sha256 "528ac3479b09a5c5e6dbe274737e140b89c8d1607e82e0003bea99b5064fab54"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6297f2e4a50a30f679d3449487c456622810a44f5d58d601aa6e60dca260073b"
    sha256 cellar: :any_skip_relocation, big_sur:       "4be78f60f79843797d07a1525db1e7657879bc1e87b69b410f9c1f26419efe6b"
    sha256 cellar: :any_skip_relocation, catalina:      "7855b136f9b36b6a390df07a386b8fee12e3a33ee64a5c727558ca0d5e5a3599"
    sha256 cellar: :any_skip_relocation, mojave:        "92f661d62c777c0695784b876be8a316f624db5cdf78255a4779e9c7709b3eb4"
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
