class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.49.11.tar.gz"
  sha256 "cb8ed88195583beef56efbb7401952d6522242fc0309f22fc857b3a515d90c65"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bd3876ae97a7b135e70408456b0826b31ceb70413f96e599ca6a1599b8e7ff4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad1bba03190c2033ecfe0fd175a44267401d05f5120eec2caa6c3efa1728cf7d"
    sha256 cellar: :any_skip_relocation, monterey:       "55f367b28ecd96100a6e487bf83b4e6cefc599f5aeab3bcab10dab62fd973991"
    sha256 cellar: :any_skip_relocation, big_sur:        "d330ff763393c6348f2d14e5789cd866de693c7eb042cbbc395456b674b346ca"
    sha256 cellar: :any_skip_relocation, catalina:       "822566d2799aa96116b888a368ca270dddea0f30c1f2d21e5d3866bfc3e214e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d68dcc196a2fc0059c12160e6ef39cfaa1ba70d4c7369ca1ef222e45dd3fcd25"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "fish")
    (fish_completion/"newrelic.fish").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
