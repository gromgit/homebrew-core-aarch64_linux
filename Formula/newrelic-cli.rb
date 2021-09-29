class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.36.6.tar.gz"
  sha256 "5a824de8a5a3461c01ff3746436b0bbdb736c8297034eafd2474be6d18f099d5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "061040edef216adda69717bf9e092239d561fb0a5335155e1f07939bca236f14"
    sha256 cellar: :any_skip_relocation, big_sur:       "48c5657028b7ffe8e26d7a54c4c58425c87e518555a4dde453c0499e784363c0"
    sha256 cellar: :any_skip_relocation, catalina:      "a67967885a02129ae75004fbe9e0cd71de01a959592c00d4746a8217a589e10b"
    sha256 cellar: :any_skip_relocation, mojave:        "f7565579d072342965a2580722335566128af578e7f114821f7100351ef030df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97cee311dd3a08e20007f7b2607f30bd98e43972b88a2d1bef413c3b9cdf1c9d"
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
