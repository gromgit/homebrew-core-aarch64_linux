class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.46.2.tar.gz"
  sha256 "b0df16b493ddf3864b09b8f8a93791ed892ab213e9bced66b291cf809b796c19"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cb5aac6745a25ae47a9c7ead7eb08f4983841426a7bf65832c1b2ae79c5c536"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eeca964e2f55ef5c3dfccc1a24f321ec4169c63b1b089a10b972c37544dd2b2b"
    sha256 cellar: :any_skip_relocation, monterey:       "177f99596b4d7dfb076a5bb9a275a7286743fa44e4b0b438844a30c5573b494d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5aec6f98c880481ac7e44dd6733a2d61ff8aa9a08769ce5b26bde47edc4ec078"
    sha256 cellar: :any_skip_relocation, catalina:       "4c9b07a6eb9b0de3c5420c460777d5103048489bc0c39eed4b812d3068f3bb1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75a8074425bc9a3b6461e9f42d1a891a25b1ae4c137e2ac6506b952a5878c5b3"
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
