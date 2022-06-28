class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.50.13.tar.gz"
  sha256 "c9c47edd680428b60090d88b951fb8bd16f71e6ed121877c153e9d74e6089f4b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c36e994a857ddef0f7dbe07d17cc14d0c2d20cf27f1d70966fb57403b87756ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a07c4075c0ffc87217e8ebff7bf0a6886b97ab11898ee9de3f62d0c7f3eb169"
    sha256 cellar: :any_skip_relocation, monterey:       "aeef6f8a85273c95dab2cb2df03b09353df6b2c7f79dbd755162ee1708299ab3"
    sha256 cellar: :any_skip_relocation, big_sur:        "80a3617b78dcd0ffde1ed0dfbf46ca602963bd65bf523f700be29244d9f2cb90"
    sha256 cellar: :any_skip_relocation, catalina:       "7caee20380dd119b99644a48f764a26bb918fa5bba95e5dd6dd65831268b7ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17a78bafc0ecfc6549a31da6dd434d04ed8ff07eec2fc15c979790c133b7fa7b"
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
