class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.31.1.tar.gz"
  sha256 "64ed9e589eef6294500baa9cece9da7b2faf441eabd1fbca5103489872f557c3"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "540bff2a033f938ebef92f179252583073e26748c183fa449ab4bbde46f5e406"
    sha256 cellar: :any_skip_relocation, big_sur:       "cb963e5cf2f6f9c07df47e1280d7dce71b147e3e6d255cfa98d1790127e8b64c"
    sha256 cellar: :any_skip_relocation, catalina:      "cf93770781d14314a1f797d06cc3c78037c7686bb794075596f3f7a284eb8a27"
    sha256 cellar: :any_skip_relocation, mojave:        "97082f12b3201fcffecf19a8c369a3a2beb88637d8bcec6e452126a3b5732213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31285d29b0acf3e2044d34ab8869b8848890d5008cb27ea63dd411a06cc25248"
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
