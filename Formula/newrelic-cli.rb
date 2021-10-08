class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.36.11.tar.gz"
  sha256 "1dcda486ddf69c5b1890f954bac260b1c7284ef8a65c738db9894ca83d6694b8"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b59546476f35e6964d8699b94dc8e14c5909cc2081f422117632704ffc39962c"
    sha256 cellar: :any_skip_relocation, big_sur:       "daa60e98859c418ff8bd82c3512a4512e2dd125be1bc6ee932c31b6afcb54a3a"
    sha256 cellar: :any_skip_relocation, catalina:      "7dbd69fc51656485efb7dc0533ed2fc87e5a636335e042bc098ae28d0a5bda56"
    sha256 cellar: :any_skip_relocation, mojave:        "929e1616331eb5661903256509a77560a86f465ecb19867ccc190fb4164b9d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84286eea7c5204dfd4e720eecdb06727a783741dc5e43ddf5ba52cbeedd62ad4"
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
