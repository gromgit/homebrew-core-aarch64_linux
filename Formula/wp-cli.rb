class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://github.com/wp-cli/wp-cli/releases/download/v2.7.0/wp-cli-2.7.0.phar"
  sha256 "4445500eaf741b1c127c60ed2a8c54e1c4c8f54cd56aaae842d38bf459d282fa"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "989ca3003da1fa718362d5201e9bec156bf7d31d312079697a1fbddc59891fc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "989ca3003da1fa718362d5201e9bec156bf7d31d312079697a1fbddc59891fc4"
    sha256 cellar: :any_skip_relocation, monterey:       "e587d3a2ab61bd86a7d28293cae22cc4b556bb5ff4faff88ebca3b2724c2b2dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e587d3a2ab61bd86a7d28293cae22cc4b556bb5ff4faff88ebca3b2724c2b2dd"
    sha256 cellar: :any_skip_relocation, catalina:       "e587d3a2ab61bd86a7d28293cae22cc4b556bb5ff4faff88ebca3b2724c2b2dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "989ca3003da1fa718362d5201e9bec156bf7d31d312079697a1fbddc59891fc4"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "wp-cli-#{version}.phar" => "wp"
  end

  test do
    output = shell_output("#{bin}/wp core download --path=wptest")
    assert_match "Success: WordPress downloaded.", output
  end
end
