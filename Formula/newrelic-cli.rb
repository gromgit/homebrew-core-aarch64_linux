class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.23.tar.gz"
  sha256 "5bda6c99f2f2a3f54f42d07a8f323b6e895e5eb38568e53c01d8af1f9baef88d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e153713cd55b3da9120895c03408bd151602e0ad9ac79900190ff31cf1d48631"
    sha256 cellar: :any_skip_relocation, big_sur:       "abf42a9edcdde564db8d88ff938c45e5fbc08cf481006ba45d317f4469e005d8"
    sha256 cellar: :any_skip_relocation, catalina:      "03e45d1e4576109d8c5620be2cc4620eb346e9df180ed1d5e6d4de64322c7ba4"
    sha256 cellar: :any_skip_relocation, mojave:        "af0d0a8b4de64dd855ad068ddbdc26b150000cc3079de7ee4c017e2a15e65274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "255ea921e31eac477caf651d24467dde043fb27a596754d4f4dc58f1cb486f65"
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
