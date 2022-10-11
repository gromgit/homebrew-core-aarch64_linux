class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.55.5.tar.gz"
  sha256 "bbf55438f8033e458c113445361d51fb31cdc86bc9da63f1190ee85b29b20bc1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bd36c0d7c5d72d129f967d1dbb2a6ed342ff95f82fa2aabf80c2d0c4dba773a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09efe064226b75530c150e88f38f1a229dfab45b452e6032c2369c86d9656992"
    sha256 cellar: :any_skip_relocation, monterey:       "03f039c838af115efb43d0a1595faca63be23e075a7ddbe4207f670a62dbf024"
    sha256 cellar: :any_skip_relocation, big_sur:        "3434034ecd6d73be9447a3f7d4eee3067e4911c1aeeb6d3c0b2df1ea57fb0575"
    sha256 cellar: :any_skip_relocation, catalina:       "97051794ba4d9c6cea1e73fb470b85308fb27e068fccc33aa06d24f93612ab0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f5d37938ed8b271fd7c040bb26747008eecd373e0b8512b31e55de35db590e0"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
