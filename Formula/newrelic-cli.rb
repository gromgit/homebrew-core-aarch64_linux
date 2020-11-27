class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.17.1.tar.gz"
  sha256 "e6f237224fe0f59a3109c32d00326869fa2331f770b0f9c6d361d1ff45995fb3"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8888cffa6d4c8432231211ba77e311787d6ccfb88d6428dc48de7410a77c12cc" => :big_sur
    sha256 "3cd9f0066f54cba6e4cca400104eac8690c73f051c2ec6edba23054e3f79d879" => :catalina
    sha256 "4b6137e90bc5d0b8884ed880a312856af54c7350af2104b06de0a277b49850a1" => :mojave
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
