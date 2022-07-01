class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.51.1.tar.gz"
  sha256 "7639c6e334ab0fb81eb99764bf47f1d4c3050905431a8e35e1ead87bdc250518"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae0bf4e930eb1ce126389fc6e8dde761066e2378e3264f14df559ea90d99362f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9f88c9dfbf6916b6e9c5014a922093763b9231bdca284bae29af71bea83c869"
    sha256 cellar: :any_skip_relocation, monterey:       "61501005d4c3f18089824e46c9d8e24a91fe3daaafd3a8cf0731096f79773e9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "404d9b8d468a8f7d91b2a78c004fdf899a10f73c37c8ec67c505f7833bdf54c2"
    sha256 cellar: :any_skip_relocation, catalina:       "cdf2b51ce699af87935137ec2c96010d7f56bc81c650e283fdf45a556563f927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2c24b401ddea904ab1f8708eba25014a5429eb972b1823f41e370447a279b3f"
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
