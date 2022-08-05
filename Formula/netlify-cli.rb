require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.15.0.tgz"
  sha256 "0cc99d0715d4e496f9a7ad442fad53a722eae498cf789e6127b4b2c288c5318c"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d50b2a69f20fa817985ec0ea32d634ae3a03f4d8cb2fec9f2083488924f970af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d50b2a69f20fa817985ec0ea32d634ae3a03f4d8cb2fec9f2083488924f970af"
    sha256 cellar: :any_skip_relocation, monterey:       "96ab0be2e937f3b225b765e86df8acb52507c12e2bff8232010dc1398115af8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "96ab0be2e937f3b225b765e86df8acb52507c12e2bff8232010dc1398115af8d"
    sha256 cellar: :any_skip_relocation, catalina:       "96ab0be2e937f3b225b765e86df8acb52507c12e2bff8232010dc1398115af8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35724f0f33f4939e292ebce5a34f557ab803e5f9a10af29547504a25510c138e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
