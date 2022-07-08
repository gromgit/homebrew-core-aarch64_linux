class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.51.4.tar.gz"
  sha256 "62552f09c51038468236ebd66c25d9515df6a7025cf3880aa721c807057af084"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "984b6f58362958223f1872bdfa81b87a5c52c933e4e2336fe261ef3646aa1df9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "310018aadab609c2713b5bf6e8a0835bcbe8231eabfcd4603fc24490f670714f"
    sha256 cellar: :any_skip_relocation, monterey:       "d710332f2a0ae5ba5eb963a2ffc7deb066952c9225ceb82640bcef6ae328ba8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fd1998f5a7b7b03d96455d81ca3520d2919daba641d8281280598a1e10fb53a"
    sha256 cellar: :any_skip_relocation, catalina:       "36c3799e79344b67dfaff4f03734daefb269dc51cf4fb819b247f1cdf9e41bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea4e27140766d93ce18514b8bb95c8c1a3523ac37fa41ab64067b8ec4f995b4"
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
