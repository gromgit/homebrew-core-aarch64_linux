class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.52.2.tar.gz"
  sha256 "b39a2c5ad22143206b0a591b611ec7a0c1b7329f1e52e9b5c5b65cdf60d485c2"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2a217b0d7809a13b8105d9644ddf4c699f1b2535e461cada8e198f9115095c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b27b799ad1aa7b1411af385d67f9a07e5af67f84276a32c92f2f6be1bded693"
    sha256 cellar: :any_skip_relocation, monterey:       "daad3d09fa71c7eebfdb06bab119b36611209aef9a22b10dd99fcf81f8c4c21f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e87d855da0a8cb4a08f6bdc5e3205b496565c66e02b528bd8a196085b88f4160"
    sha256 cellar: :any_skip_relocation, catalina:       "79037800361ecbbb2af70daa2e91a6ea32a07e2df1974cd9167aca042611943e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ebdd965f47ece92a10b973e5ab625c866ff120a3dfb15ecfc8bd2c3d27f1eb3"
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
