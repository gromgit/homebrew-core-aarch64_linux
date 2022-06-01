class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.49.9.tar.gz"
  sha256 "dab0aed370416222733396620afbad33c8049995d98f9c3392acf733ae6a162a"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51294a1f56f00ff973d29881c0cf4b332cf53a5ecd45171a3c55c2ea20b174ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30317af9472caa067efe596503d6568e253fba35f2e5d9f732e7fb33d65d3df3"
    sha256 cellar: :any_skip_relocation, monterey:       "f8227bde6def4e43fcd240fbf8e2021e5b65ee92d05027cbe443ebf3c86cc80b"
    sha256 cellar: :any_skip_relocation, big_sur:        "95ec209742be6a992406099f1e61e5177df7e7539a975641138ab89486c531f1"
    sha256 cellar: :any_skip_relocation, catalina:       "3786f64b22de1a24e957cd8cd6d18e591dfd9d9b52e08251cf1cb674eb932ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02ae83fb2931f6c797966febfb45ab797ef5ddc5a847203ee150cb5dabcc119c"
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
