class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.46.2.tar.gz"
  sha256 "b0df16b493ddf3864b09b8f8a93791ed892ab213e9bced66b291cf809b796c19"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6bbf8814c435c1b3e2370fca28e57a0ac8e81b62cc6d812a7892b7884a76c8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e552a0ade300afae003249e2617d262b624844de4889632929d4a306a658406e"
    sha256 cellar: :any_skip_relocation, monterey:       "59fe5ce602e872b7a34d987a2549d6a02bf75ec0ac8647cceb226be06187b325"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d9e24ce914ce63d0d15c8cefc346ac1ea7102f40d3b28604d45f5b5eebb8294"
    sha256 cellar: :any_skip_relocation, catalina:       "0f90eac882c37ad2e37629a74fa94ae4bae4718488a7f33066e40e1a22c61599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85eb56676eca96d13bf35bd64f9df1b6c04f76f72148e5790a14b683e294785f"
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
