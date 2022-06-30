class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.51.0.tar.gz"
  sha256 "178424aa0dec6ccc0ecd0874e158f0c7116a6f1f765491acaff4871f8bdcde7a"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aee44d87e4d18a56ae7f2043cd3768d31cd192f4fa766d14146a9f76dc2f923"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fc9ea6a128b2ad404e9e16141852e187d008a31b0b8b502dfdd8323a7e630cb"
    sha256 cellar: :any_skip_relocation, monterey:       "101b59c07fa59814f200033967e01c0da93a2d82a55441691719d501f9d9435a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb4809d91b31f29c626e9a5b1f2fb31fb01d0249a7d668d15d634ac95a6be51c"
    sha256 cellar: :any_skip_relocation, catalina:       "33e85245f48de0f332e7d54e4f8d0121059358ffbb8147d2fafa40853fdf00da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceb0a645545c560e3f273f580a068df3cae1d492f407ce0b2092362a63d1b114"
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
