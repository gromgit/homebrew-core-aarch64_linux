class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.28.12.tar.gz"
  sha256 "ebb833869579b27939bf8a9cc7307513099ada5c654d645857f2af66340e4aa6"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "359d6f43886cb9ca06887119b5a86607639ebb423354ddcf01431f314452c749"
    sha256 cellar: :any_skip_relocation, big_sur:       "4f6a0280084b09cbbeba4a51d5d7c535b2252408a3395fdd788fb4cf50c223b1"
    sha256 cellar: :any_skip_relocation, catalina:      "88939f939ad15e7b1615255f9340506a0d0dfee94b483d083f75583ca9d1102a"
    sha256 cellar: :any_skip_relocation, mojave:        "5d52a2c9c1d6de15e134670e1eac11e8a103025e0ee3e5ca49d709a4b53be7a2"
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
