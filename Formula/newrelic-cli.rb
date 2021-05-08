class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.25.0.tar.gz"
  sha256 "ef20b8240ed4943806fe0394ef8f43f18df189bb7d044f68498e1e7ef42f5373"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5176de48f8bdba3d0650c3dd46656d57279d4a92a99d37994509a122ace127c7"
    sha256 cellar: :any_skip_relocation, big_sur:       "08fbef138c6ce6701cb1ede1670a634ca922908c90494ee65da01fcb28f3dea7"
    sha256 cellar: :any_skip_relocation, catalina:      "f119302a1cc395bb69c81f926dc191388dccadb70d2bbcf98a55af6323360c17"
    sha256 cellar: :any_skip_relocation, mojave:        "10fe5a8a493c9ac3252e6f7c9f44b4865eaf2b63d025a186c877155ed18ca01e"
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
