class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.36.3.tar.gz"
  sha256 "f19ce580da8292b93421e41138418d7d81ea56df5cb05ae5ba9658a11c29b4ae"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "65f5fd2d085cc99ff748dbb79ebdb491aeb528912d0d8383278dca8c2c1cce4c"
    sha256 cellar: :any_skip_relocation, big_sur:       "e8d242d28f0314c6991fb47474484a61f9c1df5958a8258d98cc4fd06a5ad083"
    sha256 cellar: :any_skip_relocation, catalina:      "b76a644a75cb60b9a879102ac886139c51b6eebc92e097b47ff999e75e204474"
    sha256 cellar: :any_skip_relocation, mojave:        "4e3d743dcfee03bc833d4c6f16cc3f991d15d44038a13303bb76818af8a4b9d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36e39dac89eecfc32e0ad8a459e018e7f7aa7c3bab96ecbddb708b6397b007fa"
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
