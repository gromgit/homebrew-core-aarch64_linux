class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.52.5.tar.gz"
  sha256 "287ea2c595e9d164b3864da8afe3010f200df574cc7d82daa59bc82cf81b3feb"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72ce36b3891674a12ffbfe820666d1e5cc3f79781ac755453893ec2d3d9c0357"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "639c34ba9a9a99fbc9d713f19148fc381b2292fa00739ae8af8844b8b5ad6b1f"
    sha256 cellar: :any_skip_relocation, monterey:       "4d7bf63d7c7724faf5353cfbf8cc00d4fec83bbc70ec565b286ef68d8c35f825"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f2e5a2e0a290d07972b21fe67281dbbfd44c0452117c7c13053c635b02e2c87"
    sha256 cellar: :any_skip_relocation, catalina:       "5aeaf119e2e308782957440c67fbd01e4d7a54668d00d8d063b4573655e41277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bfaa3f8a52f2ebcc42f13f328f8b8f5a3202167a195059e77891788f595dff1"
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
