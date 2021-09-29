class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.36.5.tar.gz"
  sha256 "7ca598996c5d58ff809a637fefc4e6962560f74c0844483b93104d64cad017c1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1bc1d6935d496f50804b3be11bdf613898756d371232d4da02b62efdad2eeb33"
    sha256 cellar: :any_skip_relocation, big_sur:       "db80f73147d53158355d7c09ccfe495ddf5d540380d9574aee7997ec1faf8040"
    sha256 cellar: :any_skip_relocation, catalina:      "5613af9f0e597a8a2fd46936e2e44c0005ed61a227018b638c573083e7240856"
    sha256 cellar: :any_skip_relocation, mojave:        "2e125b39b3b199a68cb2f6fb3f7a1ccf8d747e914d7e3094fd750513e278e033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16e2eb71611035d490dd724a761a144de4b9c0368f82dbaed7cd9fcbba35bd7c"
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
