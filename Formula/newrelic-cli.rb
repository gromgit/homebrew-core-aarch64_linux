class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.52.2.tar.gz"
  sha256 "b39a2c5ad22143206b0a591b611ec7a0c1b7329f1e52e9b5c5b65cdf60d485c2"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd355f40e317c5670906dd36bc859744db6b78d72d0db5522b12aaedf27d7337"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2d1a9a016888477d6d88c3fcea1d1255aec796dcad06332a27f84a50abe888b"
    sha256 cellar: :any_skip_relocation, monterey:       "17c0edfcde4b9fa49d6884074fbf6d31e5ce35542507921a61ab1289abd71705"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb286d53f2cef8b33d345570e7ec11777ed409908c386dcb53d13ce93c287cf6"
    sha256 cellar: :any_skip_relocation, catalina:       "83ea3cf3a9f9b301e8a35e1f111b345e4a3acc2a132e36dfaa4bcfdd12b4c053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b204d5bfe29c4390f87e001b5ad6827e371406297f015e07c71f25183e34d7e7"
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
