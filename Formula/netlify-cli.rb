require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-11.3.0.tgz"
  sha256 "6c1bb78731af98391cb1b3816cba394dc7f5eb62d1245bb4a9891be6e46314c9"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dee64c85af6d258cc45b21892621d8c77e83094f442d98e4bc81fedd8ef2ca52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dee64c85af6d258cc45b21892621d8c77e83094f442d98e4bc81fedd8ef2ca52"
    sha256 cellar: :any_skip_relocation, monterey:       "bc3220eabb3f00d011c923bb9d2ba2ee4f2de7146a9763519e72353731188468"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc3220eabb3f00d011c923bb9d2ba2ee4f2de7146a9763519e72353731188468"
    sha256 cellar: :any_skip_relocation, catalina:       "bc3220eabb3f00d011c923bb9d2ba2ee4f2de7146a9763519e72353731188468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed4a2594494f57d473d96bbd13dbbbab881c8e3a5ad6019833225961e4b5a07b"
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
