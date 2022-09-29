class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.55.2.tar.gz"
  sha256 "e32507fa20c0f851a76f4fd2ce4a03a5e529aaa63aa671cf2486535c37468d48"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63473d39e4aa52b1bc7a4ffae13d2574524dc25d0630df18169f6905d0d3cb7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dde53b741f1baaf719ef0e700a7970e45aa57433f673de1cc16d570c84092377"
    sha256 cellar: :any_skip_relocation, monterey:       "c841a866439aa4fdefdadb136d005b0eb3f5596b47eb353908fd8903f5a29867"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2fda367be1080e17eee3edba664ba345703018eb3a9292af2d6dd221ca43154"
    sha256 cellar: :any_skip_relocation, catalina:       "c15f5a760fc05eb565d64bee5adfad080201622e9c44e871985e00dc096c0524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ac97cba7b3b5902af45bd0edfbdec0dd623cd37918668efa92ff11553648a1"
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
