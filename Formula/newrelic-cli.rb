class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.53.3.tar.gz"
  sha256 "eb2e870c06453e4fc73c64601873e70b4600b4e800f1ac58acede31c504581d4"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b13159716ba0f3e6247750c6dc19995da11d7e0bd6ce513a1c6cc59f55c29b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "785b0b0d1b7c0d154cf573217eb7d4463ce7f05225ec349e3c56c35a64aa9d58"
    sha256 cellar: :any_skip_relocation, monterey:       "291854a931611849917bf25bc9078c39b501984e7fd546adef880de5ace0ee76"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f81740f548586ed0581d643dbdec366f37debc3422e74fa1ec07c28d7bacf83"
    sha256 cellar: :any_skip_relocation, catalina:       "5c705b53ebe7c257ecc3a24f73b97228f1dad82b81468e9e9fff21464e41917e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73d05ecef0c8c7aaef80a550f9472aed5ed48c4382181a6e087c679f4befa5a8"
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
