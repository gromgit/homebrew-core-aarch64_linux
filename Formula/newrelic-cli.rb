class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.18.tar.gz"
  sha256 "d06231d6645aeb39957e1ba43a6f76a2677cdb3d8717e3ba07fe4d8b357a7fa6"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7c38d41c98fd3f86a275c23b0b635612a31b68c2fcba344a13cb689666aa16dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "68dd4d7f00f865b30a61a02cac180fcfe4561b033e065fb0be4d64ac3c6e7789"
    sha256 cellar: :any_skip_relocation, catalina:      "07a412810c622e77cc61ba4ac74d6f82b45101f89d6b536c5bd122afcd81e191"
    sha256 cellar: :any_skip_relocation, mojave:        "07e0f2dce036e5f28f226fb603823e3e2b490fb25b5ebec1c0d27af13b1dcd1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30248ede82cb4fa3d74596b55b320a2058512a8d80f50f0c5f3d2c08f475ad35"
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
