require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.47.tgz"
  sha256 "6f7e383d015ab6f45e6dd8df2ac362a179b050b6b8e449195df7436f58645cfe"

  bottle do
    sha256 "8d23b2ed22c087098dee9990b6c1ec208f05b217e227f70c3969cfe8521f8eca" => :catalina
    sha256 "c39f57560896f1472f49a24afd8b15de092a87076f084b55fc80112844658af1" => :mojave
    sha256 "0f5f47a8f2de64fc5f01df791dc2159929d1671c7df4264bac9e40816af8ec12" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
