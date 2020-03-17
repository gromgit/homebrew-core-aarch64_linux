require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.10.11.tgz"
  sha256 "fec9a2e84b64d5ba96702fc040d366b7b0e3475371628d2f4505256fe9799498"

  bottle do
    cellar :any_skip_relocation
    sha256 "1286844bd4115aa24534fb0abb2a2da1c66e030db98e72e49dffe256983c8a50" => :catalina
    sha256 "d45d32a9b5f18367c3f8121854837bb69c0b5ff144e93b29ca16c819c3f298b6" => :mojave
    sha256 "f1eb65fd82f6fcdec227a1fa0385ce1daaa306f6bd8f2b079c4af84150b66d42" => :high_sierra
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
