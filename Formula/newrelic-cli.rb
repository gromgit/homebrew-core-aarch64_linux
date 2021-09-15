class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.35.0.tar.gz"
  sha256 "ccdb528615576e754ac5c3699cc5d00b462f2e8aeb59e49d68c60057a2453aea"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "238d2ff823f48c98f775b282d988156e71c4ca1b2d75fec0dadcdda6b8cda2e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d4333e7249333296120291f98b03c4edc083404c2f7fc90c219a6b7ec43ce8d"
    sha256 cellar: :any_skip_relocation, catalina:      "2b68d448e185a17bf4b54458543125f3b988e6289e732c86641ca52b22ab335f"
    sha256 cellar: :any_skip_relocation, mojave:        "dfa65e42fe4b0e36842020bf4bbba42cbbd8c36315e63d6c18ff6a40d9907543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "836533fd6f5a7bf7ff5eaf8b12b65ae176e730f41ebaf01adf2e37e419182d29"
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
