class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.46.4.tar.gz"
  sha256 "c79ebde488250425d2aa74bdf846c077f9ae10b725efbbe6a6ffeb278eb1c2d1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "034cc9a0ac1eb2b2bed41b7607a704e5dbf371dbcda07fc2c6b31886f035481c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e62d4c6bce0078de228e83fcd1a830627d13794f8898e6faebca65768178772a"
    sha256 cellar: :any_skip_relocation, monterey:       "3aeb9ccb1f45e70de1ca03b7efdd6b418d5b75e3a5d3fbb55733bc5937341821"
    sha256 cellar: :any_skip_relocation, big_sur:        "05cf022284626edcda3b8560a25b8ce10df443841b672dc91bc10d0a4c9244e7"
    sha256 cellar: :any_skip_relocation, catalina:       "3128bb93e5493c06b505fa68f9c11f5553161942554b10c6b6c620b2a5461aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5b89200877206d40216e91da095c858b354e1e154f1a3cc1bd77941373abad0"
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
