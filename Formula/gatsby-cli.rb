require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.49.tgz"
  sha256 "5cc34948df99e3bf81fcfdd59c8b74ee181855923ff70db718f773c4cd0a89ad"

  bottle do
    sha256 "954996c3957b750156358bea80eb480d17f9e223308a13da9f21da427aa23c66" => :catalina
    sha256 "ea8dface9d468ae899b7d4de82d85d03ade462fb8b1570c2a6fb6523202b52b4" => :mojave
    sha256 "430e339b6b29dc970a7f49bb5a45e92174e96bc43ce9a8f1ec71113c3253500d" => :high_sierra
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
