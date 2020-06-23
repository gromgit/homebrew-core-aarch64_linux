require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.50.tgz"
  sha256 "716491f0fbd8448032bdf6cbabf77408d4f22d413ce81022065088bedd9c55b9"

  bottle do
    sha256 "b7bb31963e558608c6e642d42c8928ec98d7fba926c5ac22754fb1482f070f06" => :catalina
    sha256 "57bc8671dbb9c678d904717172a5ba0df480e51bde73ed041b888bd2c43f952e" => :mojave
    sha256 "8aae285f5de9c081c23f7a18710eecf220550e194b04ba90e8444061d0a94bda" => :high_sierra
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
