class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.36.4.tar.gz"
  sha256 "56d8f2d5aed77c6143560490e503374ae5788cc37378766804eedd255228b065"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "85784c8f304f18117e17c7c59c4054fa3d60ca623e6a48b5e78c079410b3bd45"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6f16649229ad3d3e30b2d5d947122f127f2876971a7c86c4952332031220f43"
    sha256 cellar: :any_skip_relocation, catalina:      "8511bac44a1455c75a2eb27137ad6e897e351e9b45e39c9158dcb79bf0e2cf63"
    sha256 cellar: :any_skip_relocation, mojave:        "68239b81651022bdfee0f4042dcb67668c4d0feaad1642c49cf80e4fdab9b01e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eccbf7ab6dfef3720d74fc60cf8554b03454d485490b9df34adc136fba48e75"
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
