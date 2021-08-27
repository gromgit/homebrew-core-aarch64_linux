class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.21.tar.gz"
  sha256 "33f99c520b0c5d194765cb523d392d952d40e4b9a018e0bb901507ed8635f88e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8719fd2eca5a2b85b347adc5a6879c7e359a9c3cbc6acbf5b466e5c1b1ba967b"
    sha256 cellar: :any_skip_relocation, big_sur:       "7f22f96be6132ad8d536a3230ec9ca977a55a91b79285c76d16f5a2f49fe290e"
    sha256 cellar: :any_skip_relocation, catalina:      "9206d7ba333ecb4ada5c0ef431eed00bc6f984890f2d1d02455431b7eda6390b"
    sha256 cellar: :any_skip_relocation, mojave:        "ad3e2e06de097c997711dee7432cbb7c6aa8078c46dadf4f28d9e8834befde32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd3321aa6ec1876fe7d64527201091e1f2a12b02cf0df98f9dc454acac41a54"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    on_macos do
      bin.install "bin/darwin/newrelic"
    end
    on_linux do
      bin.install "bin/linux/newrelic"
    end

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
