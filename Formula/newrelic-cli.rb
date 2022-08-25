class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.53.1.tar.gz"
  sha256 "5c13021e2705df5594d68e62de8caee5f72ddfe2e124a972103f3ff015e7ffc9"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4d8928a760f9abb034b6533c5c424e538816f6f5f7cd1ba14e89133deed985e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6089244520c4f96fc52e0cc013c519ba59c0f7b2e40242e66266bcddbff275c0"
    sha256 cellar: :any_skip_relocation, monterey:       "f83d696d19e3a7ab4ef91471f38d8522f1d3a4ef3d3d73fbfeecb388ec50cf8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eb50df929bce7d4c52613b98cea596a76a0bdaece12f131c01fdf21d6ea3bba"
    sha256 cellar: :any_skip_relocation, catalina:       "1c8e762aafa28f5d06a0957ea9a3b54198a9c12c9277fbd97e4cad074f5eb374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ec0fa9b828c1910ca801c3eec540512eadc3d6e172dbd7eea206c674968f226"
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
