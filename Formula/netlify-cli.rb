require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.1.0.tgz"
  sha256 "88ba3a0d406361ea7c65fd9c114e860cdfe3cd0c2c5a4d2a81aabbebc2f89610"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce4319231857ca94a2c17a6c83f9c53a0aa0ea8da2d98f884b2c981bde6734f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce4319231857ca94a2c17a6c83f9c53a0aa0ea8da2d98f884b2c981bde6734f5"
    sha256 cellar: :any_skip_relocation, monterey:       "3311c51d1318d7776088fbac67d3d52c96459ff02e0cfc54bf68a0c344dd2faa"
    sha256 cellar: :any_skip_relocation, big_sur:        "3311c51d1318d7776088fbac67d3d52c96459ff02e0cfc54bf68a0c344dd2faa"
    sha256 cellar: :any_skip_relocation, catalina:       "3311c51d1318d7776088fbac67d3d52c96459ff02e0cfc54bf68a0c344dd2faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "091e409074af9cc07b758e86ae6b9479f85a1e400e6e4c923a2c8090ae9ecbe5"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
