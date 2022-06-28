class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.50.11.tar.gz"
  sha256 "4f725ed83a130d16f459c4001023bba9bfe59316efc48b107b630bd01987f3a1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "030032854edc6ab2e036a4b925ad8bba502fb7666c08bdb8a49d5536fed986b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80f29dcb571f246a64b79f477c2686c1fb75b9330ce1b485265fd10f75c47430"
    sha256 cellar: :any_skip_relocation, monterey:       "7f3cd9690cf060ae184279ea0042dc7664c11bfb6cf464b802fa873321a93379"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcd9c0ff333bd8ee799133316d7e1b7bec6b0005a56b5be38c7924aadc949d91"
    sha256 cellar: :any_skip_relocation, catalina:       "5371bc34a8ba90edba40fbac88076b5f1d17d043c76aece93d47b5a56d3ef9fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53c78c01fccbc5e39c65216082437f901e264c599e9a974795d4baf11e7dd4e9"
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
