class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.50.9.tar.gz"
  sha256 "fcc574b00f3c02b8ca105a196f7684c6f4dd61b8b8f201b3e19d0aae4721040e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a56a2ac8816b6eefa39790c3ec4bd4e894dd54c2ab1f35ba0ccf60f9016b995"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb19283bd9def15add302ade7ac9c2a9a1716864c85cff26b90205cf601cb9b7"
    sha256 cellar: :any_skip_relocation, monterey:       "3ac40d0e2616d8bfd7b53f3812b94e1af611b86268a633777e3e005f35bf012f"
    sha256 cellar: :any_skip_relocation, big_sur:        "43f3242563676cde8a1f0cbe45cd6e366ecaa37736acb521931b15f3c1cbef00"
    sha256 cellar: :any_skip_relocation, catalina:       "e5da91d1f6a45248b7594073de0f04d7e0e8ddf6404b16964b1773b669a649fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8410f012b6ba95c4359180fec97505252211d89b6a6e964fdf2191670cba29cd"
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
