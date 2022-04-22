class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.45.2.tar.gz"
  sha256 "4570a5e8d93bd8992b6bdfd45a50e5a25f0c5c760342d737db9826dd84ef8f00"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c51f99ef15e9e8da7016a80e4b436f529a358aac8c27a7e5f0a558df1579959e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e36917f7a029b877585316d343699615a94a5d70688f03a52d33cfb13370555"
    sha256 cellar: :any_skip_relocation, monterey:       "aae48a13f30330601f0a5836a66f5fbfd7930cd241f6aca133820e20d1b2d971"
    sha256 cellar: :any_skip_relocation, big_sur:        "36a3391e3e3ea1536a8a408c1edfcaef604da09cf02e50f700f9a262a5e2913c"
    sha256 cellar: :any_skip_relocation, catalina:       "c5181c4bebb4d1d031801a3a7e28b7699380899c54fbfb4e22ea98d9bfe6da1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6e400466239e9cf3bf16a954b2dd923f26fa8e41197cb3710f1a4d9e838cd2b"
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
