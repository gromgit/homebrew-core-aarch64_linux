class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.48.2.tar.gz"
  sha256 "ec0bdd284ccf9a611e5b9be40cf4cfc7cea7710caadc400815197e967069bc6d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2b55b6d29c2849c4788a9d62f6cc953e45905507a14a4b3ff45128f6a412855"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47be514aacda82fc053b138b4abdaf93b1d2280627de69b6347319b767fd6664"
    sha256 cellar: :any_skip_relocation, monterey:       "2d1f7dbb902cc2c716a4cf3c543e81a507e32277a95ae244dafd6d99ebe77350"
    sha256 cellar: :any_skip_relocation, big_sur:        "f222d002f799005e68da319ab81cea4c2e7d2360bafe51b50fdbb7780b1e9d64"
    sha256 cellar: :any_skip_relocation, catalina:       "062e8d7eebe763b5e4a9e55226273688bf8b9617b0cffa206b2d809dd3e2a452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bbc9901360a9268403a5cb1cc6b0a84d0a48bb46c984589fafc69a7225ae60b"
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
