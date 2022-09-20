require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.15.10.tgz"
  sha256 "8e4b5b894cc8609de32203d7e8eb1ab75dc4220036ed1bce62a89e3b48026533"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ac54bccad9fcd2353ee4bb586506f3ae628be860e39bff46261169a2094d074"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ac54bccad9fcd2353ee4bb586506f3ae628be860e39bff46261169a2094d074"
    sha256 cellar: :any_skip_relocation, monterey:       "8a6f19ae0351d0c4667f8c4c1b6cc333680e5d0a693417f177e93cdde9dba12d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a6f19ae0351d0c4667f8c4c1b6cc333680e5d0a693417f177e93cdde9dba12d"
    sha256 cellar: :any_skip_relocation, catalina:       "8a6f19ae0351d0c4667f8c4c1b6cc333680e5d0a693417f177e93cdde9dba12d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ac54bccad9fcd2353ee4bb586506f3ae628be860e39bff46261169a2094d074"
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
