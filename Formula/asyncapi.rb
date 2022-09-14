require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.22.6.tgz"
  sha256 "7226e2e55d01476e5b322269a5a576bf72dfc3316bd15258bdaac8679b1d982e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06261fe28f387c0132c80aebfa61be09758b21390e78d14add8c72e9b1ecfbf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06261fe28f387c0132c80aebfa61be09758b21390e78d14add8c72e9b1ecfbf9"
    sha256 cellar: :any_skip_relocation, monterey:       "d82ba0fbf94d47b498bf2445b3e639e34cda932844570efbdd90d7396c68d0c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d82ba0fbf94d47b498bf2445b3e639e34cda932844570efbdd90d7396c68d0c3"
    sha256 cellar: :any_skip_relocation, catalina:       "d82ba0fbf94d47b498bf2445b3e639e34cda932844570efbdd90d7396c68d0c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47bc972864b57c4496cfd940b04c7032a86ff00b667b25cde3cd45b817fc5338"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
