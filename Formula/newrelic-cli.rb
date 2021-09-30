class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.36.6.tar.gz"
  sha256 "5a824de8a5a3461c01ff3746436b0bbdb736c8297034eafd2474be6d18f099d5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7e69c31287bfbedb7d8e07d4847f2ce83e8e8f721709d039e9898a3d0c6c008f"
    sha256 cellar: :any_skip_relocation, big_sur:       "de85d78d8b16d20c97c01e256a0feb3885d763a26fac7f9807e92154c6c540e9"
    sha256 cellar: :any_skip_relocation, catalina:      "420eb13694313c4a7977e811d361e2a59224cd4113d5cbd86935db0cddc9aee9"
    sha256 cellar: :any_skip_relocation, mojave:        "6f34201b913799296b09f90a1895ef1f7c09cb1665be03b994630a6547c8b7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce60b554f379ecbb414b9fcbb0587dec072518878dc0db804a92f3026975d6c6"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    if OS.mac?
      bin.install "bin/darwin/newrelic"
    else
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
