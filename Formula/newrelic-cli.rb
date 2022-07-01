class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.51.1.tar.gz"
  sha256 "7639c6e334ab0fb81eb99764bf47f1d4c3050905431a8e35e1ead87bdc250518"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "239691ace52c732361b0544726e487b80c50981fb9664d85fb7a3971401988ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfe7e1c3d64bff3fb62ff84c9fe0c94a15e5bc47dbfda87b722470881f6ac589"
    sha256 cellar: :any_skip_relocation, monterey:       "eedb77f466de003f53a41a06694b703f9de030a39a454a2e469452715410756c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b84cfe540f970282523d4fae1f35d871085870d5014021a04f4e892db392274e"
    sha256 cellar: :any_skip_relocation, catalina:       "ccae6511b1ca4e8f38fae4a9c0a2c6badda92286e5c342801bba3e442d6c5e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ae93109dd6155cfacff7b6b97e045964131bb797cd8ca67cc3451ca3353f088"
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
