class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.28.8.tar.gz"
  sha256 "82cf27f3714b9a7560e63480f2548cb6eb67575b93bec0e31f6112474bf8bee7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f4b070609bb7e077cb9d33e468d2723127ba5b6fd5fc6dce33d78c5a000887a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "a18ced0e46975b80d951bdbfdc06bb52eff3a8e31c9f1abe0db06676b3859cea"
    sha256 cellar: :any_skip_relocation, catalina:      "990ab97e7e78c8eae31fb6925d6ee9daee828f1cf7808dd49b50f107e1b29049"
    sha256 cellar: :any_skip_relocation, mojave:        "aa4297af8bd3fdfbed8a1bf676d00d0d22d08be054f41e28abc0a5afdfd5ee72"
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
