class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.8.tar.gz"
  sha256 "59d9d412dfcfe832b1b5d51de432e5275c6ad448f1aaf419f9c9a9fcc54fff0f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "792d9086c151b5522ff36f79f92e4c709c423ce42589631ebecc94df2f98b779"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42c692895529bd453a4ed17a8cca1df8cf4b25d29e08c82611a43191da0dd5a0"
    sha256 cellar: :any_skip_relocation, monterey:       "169e3de15201dddc30c33e04c723385527a5b46d689b633fd5c05b88313fe080"
    sha256 cellar: :any_skip_relocation, big_sur:        "5112cad8e6f2addb57e5006177564c226bad7a809fd2d654bb8cc55e91664006"
    sha256 cellar: :any_skip_relocation, catalina:       "f91c121b0f613f8b048e48f4047f748b4c26536214b32d93728bf43c119d272d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24567f3e015e8e6b350f8a6df1ef4d605181a6edef4767e4bae3f56ec1444c58"
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
