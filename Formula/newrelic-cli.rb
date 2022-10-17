class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.55.7.tar.gz"
  sha256 "122f902bd458cc6bfeccfde1193582138f8335b2ac9b6b1a97347b859a4c17d7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e7d8092ec83cffb8cd7e5313668f6e15ccdd6661431af606737039e1f5781b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bece026c84c8db62a8522000391dee665cd4a54266a7a5599178c39d6a094a9"
    sha256 cellar: :any_skip_relocation, monterey:       "e151ce19f1a895772145d2167cde3e0add003fdc5dd1a3e97bf20284f1b2ddea"
    sha256 cellar: :any_skip_relocation, big_sur:        "a39a200e7c1ad15c4395f768b9cd27a6c037e90745515427d4ec7a40b6945242"
    sha256 cellar: :any_skip_relocation, catalina:       "695b667e3fb86bf2ec658cb1993647887418223882bc374feb09667d6355e6ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99144bf8bddeb8d3b2acfb757418d6f804851806f75e46c001eaacca1ae5e0c1"
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
