class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.12.0.tar.gz"
  sha256 "fe87598a93e857af501ffc038f3bf4aca4fea13b4208554185721b10c073b2a5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "71f762e112d6c8873afbc798ee241dca22dc590fed421c66cccd2a305e2b9151" => :catalina
    sha256 "81cbb0996f1aeb7c85705cec2a0d95f6be33e504cb3b564521fdf09e07bcce70" => :mojave
    sha256 "429c194a582d97a7c422ac1b7d53a0547c2b0c19ac91d5d7488c64d08afc793f" => :high_sierra
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
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
