class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.49.0.tar.gz"
  sha256 "b4a61a9898c34debf2c49153a924a7294ebb2c5c96ad438f58853b83d7592f90"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "963404783b6a3a190f67c3283ac828c93d5040b8ecf3ecf7ec75727e20caea76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7bbf1e5bdf85de461c481e771ea067acf30f2b243428f1c7dea9f2984c2556b"
    sha256 cellar: :any_skip_relocation, monterey:       "9805d1a200030e0657f06b04793ae762bf60d67666aa5b8e8dc2415bef92d3ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "30cb28703dca7eb0e2524cf0722a4332d83603aa3666e242fa0e0c4133846482"
    sha256 cellar: :any_skip_relocation, catalina:       "7251db362e39744714a3722eb45093af69bf2f582d101a4163f109a021d56a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7381066bcf6567dfff9e967425d12689e4fe0e68a8e01ed34a11078942e7565"
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
