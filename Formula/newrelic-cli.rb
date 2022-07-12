class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.52.0.tar.gz"
  sha256 "a53052c82c7b52ef9a24e918c753c888c5000514754f85bd6a1b9632bd7b52ff"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc7cbf99569990430f2b36552a353783b951f3a129d62e418ee93dc81a9e61ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63ba7f555478d13f08122c5aa2a01a7f114abe00fb845b941180affccf6b09b8"
    sha256 cellar: :any_skip_relocation, monterey:       "d7562865b2182ba7c4f40e1d91d2cac0e91a2635065f9178750bc2384b04011d"
    sha256 cellar: :any_skip_relocation, big_sur:        "93838c25fdca4113a0e4b8978c956d39006974c3aceeaccd20b0c8e082171cad"
    sha256 cellar: :any_skip_relocation, catalina:       "adc9fd25f5d240c7f83897b311a3023be792e365ab73bcd97e3c1c1e2fabf901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "875da6b8c298d7f4ab845705cfdc598144918fb3996695bfd44c7f5947021b0a"
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
