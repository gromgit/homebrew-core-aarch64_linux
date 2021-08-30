class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.24.tar.gz"
  sha256 "286530d2c2f518ae198d90c06e1d8cf3ee5b58673d6a42b1381c083ae36ef995"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f4de82a2f253debd8a362fb6a6115b8eb903055172533dfe70f9e624c1223ba"
    sha256 cellar: :any_skip_relocation, big_sur:       "7e8d090d66049b43925c8ae5e4335741c9eae7a12ea8388e23c799a40487adb3"
    sha256 cellar: :any_skip_relocation, catalina:      "0e68b9cf04ff62a157f1d323b5a28a4b84e3382e20fcab294c375ffa55a84f64"
    sha256 cellar: :any_skip_relocation, mojave:        "84604d53840f7455b3480de5ff20c66514b1df8139e674c6381271376be7bcae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a5a80d5d0f5211c4380a53984712d5e4ed9dd255c73998de56dd1957c56f78e"
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
