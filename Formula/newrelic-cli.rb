class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.49.7.tar.gz"
  sha256 "ea4d446ca50724a887361b49f4bbb42315c16de1aaa487f9f7a309ed8d7a8ad0"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d81e01fec498b227ba849754e9e364d54e8064c84b6046a4ff804e9cd0649f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d8eef5208d8a44c7c40599d22bc3b0c7653d568e52eca04632d0023b454154a"
    sha256 cellar: :any_skip_relocation, monterey:       "8cb80f00fd0f597e3ff9799f75d405e5d2edc796288cb076247d413b0477b7e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2279deba15e91e4c93a1744246077adbf35c05eeccfe1b42b8756978bc3e49a4"
    sha256 cellar: :any_skip_relocation, catalina:       "9250a620855e9183b2fd3750f3a1a19b048891d69265f3acd9e63628b3b68803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1271aef589f20ef069ef9fe30c5f41c34072b51bc99c378940fb7c9398c2be88"
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
