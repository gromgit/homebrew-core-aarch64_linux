require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.56.tgz"
  sha256 "cc8658c75108fd1ed1aaeae928b7bc61ea854d4c2d77ec501bc2c44981800336"

  bottle do
    cellar :any_skip_relocation
    sha256 "36e39b005ff2c140de0938f9158a20edcd1e6b370035d5c44136942e5d78a401" => :catalina
    sha256 "e035df69d61fb7eaba285b11ae5a88ee6728cf91e2f17db18dfcb591886382ee" => :mojave
    sha256 "f558d58968b546a224bb1cf156e9240948618d43f1c09b54b9fd92d4c7393812" => :high_sierra
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
