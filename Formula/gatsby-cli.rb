require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.0.tgz"
  sha256 "884f7642130a793cc888768eb3446ac2ab41b41ea61d3e9a07ca221d83c2a417"

  bottle do
    sha256 "8fd66669c07a2b6f99fd293b2c576a2997ce8bdddbaa9d13cf9195489446ee5d" => :catalina
    sha256 "578b532b7fa6b189a389363d048e106bd6b911adcfd36d5878115b012834fec3" => :mojave
    sha256 "34c86a39e5a372d31893b04404aaf02b5c6cb91b767ce4c759281995f46147d4" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
