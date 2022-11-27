class Up < Formula
  desc "Tool for writing command-line pipes with instant live preview"
  homepage "https://github.com/akavel/up"
  url "https://github.com/akavel/up/archive/v0.4.tar.gz"
  sha256 "3ea2161ce77e68d7e34873cc80324f372a3b3f63bed9f1ad1aefd7969dd0c1d1"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/up"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4719795858aaaa20490fc7faf9a36151c4ec9f6deb28053002a25ccce3e2a869"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "up.go"
  end

  test do
    assert_match "error", shell_output("#{bin}/up --debug 2>&1", 1)
    assert_predicate testpath/"up.debug", :exist?, "up.debug not found"
    assert_includes File.read(testpath/"up.debug"), "checking $SHELL"
  end
end
