class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.52.4.tar.gz"
  sha256 "7a27b42d09195d1641a1deb91649be34faf5523851da0c32f97fe1281d2dd59c"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaae35581267c73684dbc56322d42eac7d576b895af5eb843516c6458274481e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a48dbab158c9d0d739498b8844c3a8c13230a8c3602fc2134988e2d93f86f2d"
    sha256 cellar: :any_skip_relocation, monterey:       "5c8dc80591eef3483371a8dcf766372ad8a6396d98bbe3b0e1dab260c421e40e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d9d629fdf572aec9648053f322d1a978174ece8e0f5798269e10e5f48992e7a"
    sha256 cellar: :any_skip_relocation, catalina:       "4c8ccbc64e052ea1c95ae5b518a699b089fa75e0649bf5bf143c42cb9588e6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f3a869317f3509b9de279b09ae7ecdf74bdd899d7fbdb73fa6871cbad298a93"
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
