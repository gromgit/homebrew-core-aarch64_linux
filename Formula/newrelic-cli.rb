class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.36.0.tar.gz"
  sha256 "a157c6d0a3057bba796717ed9c30fb54dc18173c1b6f3af6ab0d21eb8f52ab94"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "74043c31a383cb5303e7a61fc30294af9950e2eba86f22e1bf6bcdeafaf8ad67"
    sha256 cellar: :any_skip_relocation, big_sur:       "a78d7a2379ef3148a9e753a9b71cdecc91977c5029f4803b0ea1078d54d3c55f"
    sha256 cellar: :any_skip_relocation, catalina:      "eaff727cccc604c9e8fcd1bd4adaed1a7f49de5c19f17548ef0633e49baa6826"
    sha256 cellar: :any_skip_relocation, mojave:        "856df9a18b63dcf9577ea8778dbe24478dad9ba1cbe80754628a021ea3ae6e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a23763b045d5c24440de8b230c5d64344a384a53cda36cebdfb07db85802b567"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    if OS.mac?
      bin.install "bin/darwin/newrelic"
    else
      bin.install "bin/linux/newrelic"
    end

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
