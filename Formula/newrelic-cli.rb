class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.52.1.tar.gz"
  sha256 "77f43f1c59facb7da5b017701770ef1a2f8054520c0b4c7972b20773d7ec8bd2"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "282403adab0f2c65a8b98db0230cb4a0dad4219ee8a5c547bce142d64b92c5b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6569b43b6ddbc3373d67103cebf067858e8755735c138370bf72ae6b8e77e71"
    sha256 cellar: :any_skip_relocation, monterey:       "436db068beab28fbe77153ef3be0c1caa2f602076191a19525745d2146196ff1"
    sha256 cellar: :any_skip_relocation, big_sur:        "18bfb4eb4775c45de490386afeb8d2842cff110ebe2732e8ba2e81e755570b82"
    sha256 cellar: :any_skip_relocation, catalina:       "06e0ae8d8de6c75d7a378303363a59218ae279757ca0904d5a94b6b52daf67d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0be08fcd57a5e549795a97a1082bd82af56e4707ad1d5ba47e917ccf432f0e3c"
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
