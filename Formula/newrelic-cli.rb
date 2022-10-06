class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.55.4.tar.gz"
  sha256 "c7f8617379b673d62d8434d4dcbf2f257bd424045b551f5c557975ec53a408d2"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6702ee08f34ac27ab95de1e5ef70004b1eaa3e2939932df7952b8fb27483c374"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bd02c5e3edf7a5a9740b1dd0089cbe3ddb4fdd71bda2598722514e3c8c61f34"
    sha256 cellar: :any_skip_relocation, monterey:       "bf2cc78f7612be68501da8185e90684416605ab2d2cdb1d88838e10876b2b490"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd872feb90da54eba1602e8028efa3bca35b4d0a9c575e24aee7b19ef70b37a0"
    sha256 cellar: :any_skip_relocation, catalina:       "cfddf0bda7c6f9dea1f26bfeb2eab160975c202ab21ccc9917bbc3b2445de178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea1d0187811591803e26f2c7e3c180efe6ce64b68d5ab2a475637bad87c9eff9"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
