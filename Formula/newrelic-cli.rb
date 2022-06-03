class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.49.13.tar.gz"
  sha256 "37eac9d70512e82c22012c58e8f55aca07779abae28ea35866ba924867f983ef"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "959b60d4172a2866fe07d907213260fa2723ad2b527a0b5e35609902af222a03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74052407253ec64b2ef15c05b8691e4ee7914342064f26ee5b423f3c819819c9"
    sha256 cellar: :any_skip_relocation, monterey:       "8ae73f3d7fb7f3c850b6c0f669555c5d2f08c56deef7126d4ecd5b4f625fa896"
    sha256 cellar: :any_skip_relocation, big_sur:        "c04a90e47da0ec33cf3f8dd6f15b120139648a435f69e0d8e2297fa2c460bc81"
    sha256 cellar: :any_skip_relocation, catalina:       "1a6f1f5509c2f3179cd79da3552d4ace5e9bc2163023fdd2b5ccdfb789360ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3638a9be2b2df5523eb76f358975be4d7b0aaf31a2423e7b45974cb65b930f75"
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
