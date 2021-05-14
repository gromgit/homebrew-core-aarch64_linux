class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.26.1.tar.gz"
  sha256 "e02b405bd57a08058306342a3cc52eafc8b4eab5a37b99c1844720c36f8196c4"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0afaf691c90cafb989bc4fd5bae5d4b4d2b96abf730a84a1cccaa1cc31080a49"
    sha256 cellar: :any_skip_relocation, big_sur:       "194325730c6f036be9d1ccaa19f5bfb1f0357484abb71feff53a373e2ea20004"
    sha256 cellar: :any_skip_relocation, catalina:      "1937afdfa81db654cac6e4b06ba71a10f90816b95eba9d568ce52de275ef5b32"
    sha256 cellar: :any_skip_relocation, mojave:        "1afc5c145948bbccf917fe34ad2363eba91efed9ceb8374622427c156052edcd"
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
