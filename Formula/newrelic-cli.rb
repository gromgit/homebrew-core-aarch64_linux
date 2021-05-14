class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.26.1.tar.gz"
  sha256 "e02b405bd57a08058306342a3cc52eafc8b4eab5a37b99c1844720c36f8196c4"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "df6a3b4a7e4655e1ac96096b80e7207284b8dc4bfc211ce44ead4c4bec731c64"
    sha256 cellar: :any_skip_relocation, big_sur:       "6bf3ad4fcb40557ae66c6cfab02d63b32ddd8bcf2d40f9dd904e0d20e90b3f76"
    sha256 cellar: :any_skip_relocation, catalina:      "03cf80984561d5f092f1cbf6b37dc24a4d100feadceba757cb867c6f5026e4a7"
    sha256 cellar: :any_skip_relocation, mojave:        "3ec1906199a8bf78d9a627c832ec0f192e72cfccf7d2e8bf5c00efa895a699e9"
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
