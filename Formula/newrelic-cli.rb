class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.49.10.tar.gz"
  sha256 "6463c604b3e3ab4732163c3398d5f526891151fddcd516bdc88b4f03e57a5255"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71fc7b8d16a8e88641ef276d9a8b92538f2d6cdc1994fb1a986769a875b3e3b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ffe11520d2da224884f799da05a82660a4e237af35c7cde8b47076d36b62a5f"
    sha256 cellar: :any_skip_relocation, monterey:       "6366de9017d951c685180e759033f327d6e0b4850363a27d19863c4ac6753978"
    sha256 cellar: :any_skip_relocation, big_sur:        "03a27961a7f9287e1ee7034a01f10e11bd05970cfd05957c548b731759d833d7"
    sha256 cellar: :any_skip_relocation, catalina:       "0fedde5686e8aa405e315d721ff6d902c45e319297aa148b149842b2cce5ebbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00d2bcd7e5865884cfc888b04a1328811d09a6e97b38d1751c2c61fbcce682c0"
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
