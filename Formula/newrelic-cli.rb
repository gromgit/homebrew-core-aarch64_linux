class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.31.tar.gz"
  sha256 "fc900d354e93e4b917cc80aab8e4a5a43ef7a6544193e6a6121dc6b89ed626db"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c2320133e79967c171041941ab251c27399fd0811b3afd4364a4e0c29b0ebde5"
    sha256 cellar: :any_skip_relocation, big_sur:       "f2fed8f7415f5edb897a768f99a5b33ae06cdbbac638f68fc4bf7843bf217d43"
    sha256 cellar: :any_skip_relocation, catalina:      "7b8ce9cd2f2f677959ada1fb1004743dfac2a451423e94c418eb6f1394e9cca9"
    sha256 cellar: :any_skip_relocation, mojave:        "2b1d7bf3c8fd40212ae3d9f152c919d1281fa188a7c20041ea1261980234a1de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83c616e087d3bb21026d1ce80c0bafcad2fea8c86da81276c94e6af4a9bcd713"
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
