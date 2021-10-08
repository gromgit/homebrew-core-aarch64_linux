class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.36.11.tar.gz"
  sha256 "1dcda486ddf69c5b1890f954bac260b1c7284ef8a65c738db9894ca83d6694b8"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c1c473c95fb3b9e321754909212e8d463cefd32bc8e22eeeba3eda47762c032"
    sha256 cellar: :any_skip_relocation, big_sur:       "dd8e22d65739098b4ef423babe8eb8bbf4eaa0b990b8340d9aee0967117e5089"
    sha256 cellar: :any_skip_relocation, catalina:      "6f2b6adeb2c7ebb4c655c8566c41246bac9038399ea8ccea4dc91c0afe23d10b"
    sha256 cellar: :any_skip_relocation, mojave:        "51e9b8820f092502dc3a57606e1bb4f9963e20e4a88ad15121908eadc92638ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d47275d023719189a718915770dedd0941f4430530319e2018ea1f97bd788890"
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
