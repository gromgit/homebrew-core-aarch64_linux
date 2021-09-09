class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.34.tar.gz"
  sha256 "0cd4cded657e81ca789575e922c1fc38c9ca0d11e49ce10855d25258fee42f6c"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb96387256ea36b2ad0990e8bec9919a01ce9f7c19e220c1fa1b44ba0a3a483f"
    sha256 cellar: :any_skip_relocation, big_sur:       "edaf202168b418e953d665a235c4d62b90fb325687324256fd02d91c5b33f5ff"
    sha256 cellar: :any_skip_relocation, catalina:      "baaf0a441ab8a4e36691e76b4240a9bab4a4ac84d15dcd2b9365c1f3755ee668"
    sha256 cellar: :any_skip_relocation, mojave:        "3d2567e789a41495cc2d8cefa770c1f4d3a5d651383201c3f7173d3310a30679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8808c3aa3bd98ba47fd872ce323b3f90387ae86fa88e00baadcbe98d2c2be61e"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    if OS.mac?
      bin.install "bin/darwin/newrelic"
    else
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
