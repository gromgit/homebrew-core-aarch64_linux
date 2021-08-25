class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.9.tar.gz"
  sha256 "6f0b080afeb06cac2db3d9417ff94beb74f2ea0d3e6726cecd780829dbc0f043"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a57d5f149349a8380b7b69cc28e4c324a580801d978a96ba8053534efd802483"
    sha256 cellar: :any_skip_relocation, big_sur:       "903466bcfbb0a96e94005a4ae1f0919de999469c38c70e8924ebe059476f61b0"
    sha256 cellar: :any_skip_relocation, catalina:      "9f90c4df6f9e0505a0b910f0a09640c9f759c08ca285fee5ccc3221641546a68"
    sha256 cellar: :any_skip_relocation, mojave:        "c37784bc5153ee6258410b0908e460bde5fd39d338ef6a52336d3d8db83f2b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9319734b5d7542173eb11af05ef171a1c5186dd261c29977f86b604c6e060a28"
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
