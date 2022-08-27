class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.53.1.tar.gz"
  sha256 "5c13021e2705df5594d68e62de8caee5f72ddfe2e124a972103f3ff015e7ffc9"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e9ab80765adc7b301942fa0c3f1e4c6b539173e2cc595d56e6a2cf0c609230d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c18cee4a206fac6382cb769f106ba3665d47656fcb3706574c4b76aed5c2998"
    sha256 cellar: :any_skip_relocation, monterey:       "6064f7a5b4ac8f5fbf9188c4f578ec20ae3b03afaf8f826e008e9a892bd5489e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c498e9dafee6fdaecaa712c64d83265a8dd873ce4028e999b32a5af903be228"
    sha256 cellar: :any_skip_relocation, catalina:       "5f75a6b6826c219d5a55dbe9439b2bee5b4952fed6c1383654cf77ba64cc9fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "315f071ab59930c2f205c50ac3cc8a9c9a0c8f07c8318272e3be2d204e945f79"
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
