class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.46.4.tar.gz"
  sha256 "c79ebde488250425d2aa74bdf846c077f9ae10b725efbbe6a6ffeb278eb1c2d1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "373992e240c829a3f41d12bfadc5f0711cea6a4bab7d07a5bb778c32ec88d4b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24a3382043d32e646989dd4b563a93917a16fe6a52fe1976544c3a8466246061"
    sha256 cellar: :any_skip_relocation, monterey:       "43fd372efc5242f17bbcd6d75128dd89d3dfdab43cf338e0e2acfb1367cc685b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c17f20093e21e603cea63a54d3075ca742c40cdd6f458eb7c9cbe7dbf2480c0"
    sha256 cellar: :any_skip_relocation, catalina:       "967e53b195c49d9266ab53655149f3e4e5c362319c141ed38bc0714e54ddaca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bc25d638975e6f0d5d23f669d59319ed4dbada72d4e686c9818cec43059465b"
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
