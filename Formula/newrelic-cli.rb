class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.27.2.tar.gz"
  sha256 "89436a8ca2812968543535b9e593d95d8b1e949891a97359eeff8713dc294472"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7405e408abc33b233536f2a6a1d7f1a582e4bf8c6b18e21d9498adb1202c8e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "e1ba06809f2cae49bcb1c072a50b86071cea41fa8155917d3de94211767cda1f"
    sha256 cellar: :any_skip_relocation, catalina:      "755d4fd3e7bf8484edc9b931745873f0e10769ea61b08c9300289a093aa75f0c"
    sha256 cellar: :any_skip_relocation, mojave:        "46c69c8049cdb79bb34475098d4635bde69abf4f43e4ae71e7cda125379a6c42"
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
