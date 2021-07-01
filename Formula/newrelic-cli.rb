class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.29.2.tar.gz"
  sha256 "449c29a6d75e03c71dad907fed06936f2ca110b6007946cf5b13dea46dc1a7d1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0586211e5909e6fbc1764504c4858343f52af155d783c9c4712dacf8dbe4a459"
    sha256 cellar: :any_skip_relocation, big_sur:       "5398f234fadf9cdd09ff281afaabceb095eec5c88329abdee10879f337b73496"
    sha256 cellar: :any_skip_relocation, catalina:      "83613693dd16e105d215766e334d0a673440d533616409b9e2d237b613fb35fb"
    sha256 cellar: :any_skip_relocation, mojave:        "f64e1af904507360364719c5d40d98035bdae30de9d01aea4ee49b41a0f6fb97"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    assert_match "pluginDir", shell_output("#{bin}/newrelic config list")
    assert_match "logLevel", shell_output("#{bin}/newrelic config list")
    assert_match "sendUsageData", shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
