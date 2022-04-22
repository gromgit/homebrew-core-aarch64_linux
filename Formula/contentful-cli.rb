require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.12.20.tgz"
  sha256 "3e8389024c8758fb03bd23506f2820748cffa4d9a6645c6d1bb50d0ee14b8245"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59e7fd5c210f3f9518247060301f042053a229a9ba37ae7b285a0489ee8cd0f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59e7fd5c210f3f9518247060301f042053a229a9ba37ae7b285a0489ee8cd0f7"
    sha256 cellar: :any_skip_relocation, monterey:       "5b3fb846194abefab020a7405489307450c85d2b3131a59400a13373f4b14255"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b3fb846194abefab020a7405489307450c85d2b3131a59400a13373f4b14255"
    sha256 cellar: :any_skip_relocation, catalina:       "5b3fb846194abefab020a7405489307450c85d2b3131a59400a13373f4b14255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59e7fd5c210f3f9518247060301f042053a229a9ba37ae7b285a0489ee8cd0f7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
