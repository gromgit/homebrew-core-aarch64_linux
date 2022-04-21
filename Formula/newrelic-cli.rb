class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.45.1.tar.gz"
  sha256 "9b16765163110ea75a8eb084fd3a281fc52f4f2eb70cc9e5bf3694bdfaf20dbb"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88e50086029c586b4c39b9259a5427a302da19085b2951d8316755881a639ff4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d56e2b57b29acd46d2a2bceb0ab3dfa7d47584b43d759ed8693e13c5d21b6cd4"
    sha256 cellar: :any_skip_relocation, monterey:       "d16b258185755469912494f9e43594493da5a45be64a31f48792843ffabc904f"
    sha256 cellar: :any_skip_relocation, big_sur:        "47770666b5d06776398cf8f985305abe7be08a34be54145b554b59184f3bc32b"
    sha256 cellar: :any_skip_relocation, catalina:       "14c28303ced98ed34efc75bbb2a3b0c3695dfa6fc541cecc1e5b8d120d83e221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b76013ca70d4e4efbb908728c91a4df74447dcd4cf174d66681513873596bb4c"
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
