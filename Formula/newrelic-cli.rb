class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.54.1.tar.gz"
  sha256 "8c80f43d14ffc510d74a968f2b6d5bb79b486ede217afaafc85619745e49045b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e333a19f75b27b7b7fa03ef21d39bae20fa3a6b185516b550ee5e6f477ca207"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5abb8b39e9493a342d3217ca7a5098fa578062832205a36ade49caaa2b376e0a"
    sha256 cellar: :any_skip_relocation, monterey:       "8ff2eceb6bacfa277c9889753c8e8c3e84a9636dd8d8b664465bcd758e886107"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a6ea81a1f96d9a04f3f2046cb92c1df977b58d55edc82d14d683dbb89468db5"
    sha256 cellar: :any_skip_relocation, catalina:       "73094aef9e2d3b97ca9f83fecd554abc61cf48fc2b3ced0b71807434dea0d642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c74155cab0f423e9a13abda317bcdcce0d510ffdac91e5016cf3a1b1b07634"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
