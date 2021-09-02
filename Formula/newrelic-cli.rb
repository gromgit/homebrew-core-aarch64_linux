class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.27.tar.gz"
  sha256 "bb74c57836ae032505409110def2afee492e1a75f250d686bd7a30c31d6d12d1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e1abf2a83cd535e5e37a7f8e98d58e846de4eb1074fdd630fc530fca10fb49ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "96b4153a1a4e87a8547d142944dcf04e07c611764721d7cc3c56723e7bebba82"
    sha256 cellar: :any_skip_relocation, catalina:      "6ba8ceb36687238bc873e5c7bf463d7a1fb47fc52967c5d4421cf7eb63e16232"
    sha256 cellar: :any_skip_relocation, mojave:        "69de82439011d583c3b4ea908482093386a245532e22b3dda8abb7768269220a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d70062ff2182a4b90911ef490a0cfb484353fdb8da387164d3807225f9e73583"
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
