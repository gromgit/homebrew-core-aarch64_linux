class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.27.1.tar.gz"
  sha256 "62fb4f3bd09f11f2a783165779e8724cad437cf5d168ee317ace63ef5e08a332"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc75599d1ad32ffa5062f8d94e349cc5722e994c3bfb855ab9db2fe4a142092d"
    sha256 cellar: :any_skip_relocation, big_sur:       "b2dcaa754d2033ee19fca11a83a1865d9c0428f0a7c62fab9a3087b02ab7f3ba"
    sha256 cellar: :any_skip_relocation, catalina:      "092c7c2443c277e6617d39b0a032145289cf2b44c1d9cf39011f20fd52c9f66d"
    sha256 cellar: :any_skip_relocation, mojave:        "d4453c91bd5383d24d23304c20c7ec707e12135251be1bcdf227a77a021f3276"
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
