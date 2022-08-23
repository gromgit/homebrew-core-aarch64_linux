class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.53.0.tar.gz"
  sha256 "c212c4bbdecfb80de53026cb0a415c937e6685fd2a623f79b7f96acb53f8f6d7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61ff2c35e87f5dead8a77983f8e02144421a0dae98a26197f97d8a894e91b2a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd4e3c9e6f56a1da0d707399daa05a4947cbf2e842af1d751a905ac0573c3711"
    sha256 cellar: :any_skip_relocation, monterey:       "54d24125ae12377c8a0de5ec3e76578644c99f4503e4f30ceb1ba88eaee5a152"
    sha256 cellar: :any_skip_relocation, big_sur:        "337a169a21c6d69f5eda9613c55c854737da4808dc0778b483212dfad57cafc7"
    sha256 cellar: :any_skip_relocation, catalina:       "d8a65fe6aac1e01a76eed185b90baf9b525a1b19904b0684e61b23fc3c81fcd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "417c52196f451f7807b777aa5bd0ca76893496be880582a127eb3acb6d6a9b67"
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
