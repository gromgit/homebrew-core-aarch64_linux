class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.27.2.tar.gz"
  sha256 "89436a8ca2812968543535b9e593d95d8b1e949891a97359eeff8713dc294472"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3f7d0130c0676ad788d3325d8dd91b8faf3c180e5e30b48e5d96f51c3de83b7d"
    sha256 cellar: :any_skip_relocation, big_sur:       "e01108459989926059b089779b3b57845e3f50a006ed9c7c69da3684d828005b"
    sha256 cellar: :any_skip_relocation, catalina:      "0ad1ba95246bed67357db5a9a0f7333cf28e0c462667374c39d9676b542106b2"
    sha256 cellar: :any_skip_relocation, mojave:        "36c43bc58b61d44291abd3260b035fb8b87f4492efa60e0d12736c17d00c81b3"
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
