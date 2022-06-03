class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.50.0.tar.gz"
  sha256 "7bd4ee88a8d9ecc152314c31693d5b2d9199f13b3d650f3c96fc0e9afcf9f003"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e7ae40da50f5d1e4cc28637cca47c10acda4ff5d918fb899b7f195798aae943"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1ef922c47639d68eaec33e03b8e8a09dbd45349f7fd87e861dc1c365e663261"
    sha256 cellar: :any_skip_relocation, monterey:       "5620e4c03e051411cc25279b6adedb6ae4ee4f96dc4ca46ff10234a768a641dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "77275e859bbcdd406f240893ef21845c20ce7206e827bdc3f8b5aa473858ae5f"
    sha256 cellar: :any_skip_relocation, catalina:       "35962d0f71f01a6b2cce7d4d56a92538d07a2296b1acefade153dcec35d5e996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcc6bd58b68016fedb2ef7fe2aec0c374462a6f7bdf93a6d222762f93b63c33e"
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
