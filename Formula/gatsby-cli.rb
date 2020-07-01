require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.54.tgz"
  sha256 "5972366b46f053053faa232aeb2797639e01724c9cb763b57529f4765dc30487"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9c0cdee15aaf6416ef7ea5837c8ce7fed8a2ee1effc1406a9a9ca2da5f2153c" => :catalina
    sha256 "e70ccc502aa46a029c4155244bbe2dbbbb82be975858dd7f5983f56506447726" => :mojave
    sha256 "41988d184bfddb66326303a2463079647692906a5a348a2ac74539c7204625a4" => :high_sierra
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
