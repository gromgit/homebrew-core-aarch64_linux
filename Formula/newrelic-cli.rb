class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.36.13.tar.gz"
  sha256 "e7f9d64cd6b5c23f22ea5d89bc16e9fc504f48a00b38512b6507ad5bd549fd81"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "94d9cd12bf338f70a5b23128e004d26ed16e296d18b5b9622c904d3ed37cacdc"
    sha256 cellar: :any_skip_relocation, big_sur:       "37877fbac786adeb311f623b94514223a7226805cb602fff90d13b5a7d4640bf"
    sha256 cellar: :any_skip_relocation, catalina:      "06270f24dd13acf317c7560203cad1c94e22f3d6dafacb2bc07db287c29390c6"
    sha256 cellar: :any_skip_relocation, mojave:        "935c7052690b057e0aca166bd34dfa4014af056aa1a8fdde9e1a5d8cb5607565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de306b99ee98f0ad88842f83aa4a5978c6405bb3d9c5c6cd6378a3ba595dcfb1"
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
