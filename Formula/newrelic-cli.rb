class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.35.2.tar.gz"
  sha256 "78d38128494f2dbd5e908747bdfd4acf6098da84f2fd23c7936e93216e8e6e8a"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea0ba5726988e6c5b95adb6309c2f400f1ebe10895bb1bc709b12b2395e34279"
    sha256 cellar: :any_skip_relocation, big_sur:       "23b0e5e4b218381c47ae13299d34d26f9867d1c110a09a163309a96ea19b2b47"
    sha256 cellar: :any_skip_relocation, catalina:      "e4616c3bc45a84a8f8f7cdfc9ce34ae376fb11c8e944ee209686196230b97352"
    sha256 cellar: :any_skip_relocation, mojave:        "f0e3421ee9c6daa5d207f5223c5242505c1c7fd767682e159f7f5e9d88f0d475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a02513caeb8715f92adc8e7439104885662f29e6cbed2e11c965169328b8bdf"
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
