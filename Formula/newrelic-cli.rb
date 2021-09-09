class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.34.tar.gz"
  sha256 "0cd4cded657e81ca789575e922c1fc38c9ca0d11e49ce10855d25258fee42f6c"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8e07edf381cbd878bb5a5603dff4a0856f32bde5c67a84d0262b922fb62cb14b"
    sha256 cellar: :any_skip_relocation, big_sur:       "90dae0b880e163b4390f75e44ff388f782c172000a9d22d051453f62c684757b"
    sha256 cellar: :any_skip_relocation, catalina:      "6a6cddeeb3efbf76fb0449503bbaebf7b9529641820bdb92af77d077090d9b9f"
    sha256 cellar: :any_skip_relocation, mojave:        "644fd9c02a41d6dc788c80164143ab0e964b7933c9f71d5639adcb419523394c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90d250785f8099cf04fac7466d9f9cbee4149c33f903a06163c3a989c3fb22a2"
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
