class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.47.1.tar.gz"
  sha256 "f128e0f8c994393cb2de754d1cefd870b3c5292c45b225778531e2ecae243093"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4facdf4818b64e04da3db566ceffb3823f86777a1b1eb4c10fc00339cc45963"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f16a714436cb05783e8649cfa67399c876fe2564dfea3163e83f712db478410e"
    sha256 cellar: :any_skip_relocation, monterey:       "d6c58ceafd97fbdeec99113213b55ec84d765a8f4981f0f7b914a43de18cd376"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd3d580f62e9622dadaa637340ed6862b7b6bdf0eb2d360bf037f22d68365b61"
    sha256 cellar: :any_skip_relocation, catalina:       "c7632601f8933764f9203ec5a253f078ac98559e65602e0fd9fdde45dc0c1983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ad0b2b7b61f20d367e54f194f79457ef4d8142bbce5ad8bf5518dd39d680093"
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
