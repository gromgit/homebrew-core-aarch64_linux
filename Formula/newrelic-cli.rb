class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.55.6.tar.gz"
  sha256 "46c16345583193576a061161c3c587ad440f5325ae8aa106f70ee740542806ae"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00459dd06eb2e8a0320bfc22835add97e148420f7117b19955c8c0f9792e0889"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2e825741feade284fb15c4c527c84b2e05aa2691d0d7b8e056788712d940bae"
    sha256 cellar: :any_skip_relocation, monterey:       "684ef0d948a33d79d065298e28251f89a853c03e017c92f1e2a76823b0fd508a"
    sha256 cellar: :any_skip_relocation, big_sur:        "84eddff6197712666c7dbfb4e9accdd5687d08abc4ebb4a0bde50b632ac6611e"
    sha256 cellar: :any_skip_relocation, catalina:       "6adde763c185bebb63375b07b96fe33427249918037cd68b13439ace1f0d9763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc9542c18a2d69037adcee6aee787b36b620316b607760f5898a67cc83b331c3"
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
