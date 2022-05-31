class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.49.8.tar.gz"
  sha256 "b2efcd4791c50a72e3aaa3953ad6f129cace50c9f8c1513239a90b6831bb20bf"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a2b3088c9728d6c418c6c9168df1bd118a8732004b8063d10d5c5473e66f3ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72a02eaace51bb078e0ee5fe06aecde94f2197bb0384f334aab56767c002d935"
    sha256 cellar: :any_skip_relocation, monterey:       "458db3327d3ec68b51afe618e3a4968af601decc44488bd31565bc7cfdb3f998"
    sha256 cellar: :any_skip_relocation, big_sur:        "21a7c381975edd29e0b007bd74abd226865b453e43b1d6cea833a6b80d7eff2d"
    sha256 cellar: :any_skip_relocation, catalina:       "7950dd768d9c454c8770139073d27a75d249ed3c680b28c7189b929efd82e1a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1decbcea8749533bd51ea7e50ff7b009a666552031e32f458b696b4ef4a0e860"
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
