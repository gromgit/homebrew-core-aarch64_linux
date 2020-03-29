require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.11.3.tgz"
  sha256 "4dceed29d23f01404d8379b4de21d1206ef9b696dc0a003ebbed3a2ec2fd0e14"

  bottle do
    cellar :any_skip_relocation
    sha256 "97a4d8f85fddc19c3a5d209e782a1f4effc30b29a178bcc4f8cb91d087642faa" => :catalina
    sha256 "f5b5c3e75aa1792f9819e523d640b631cc42bdb507cf69497abf874c90d543a2" => :mojave
    sha256 "56b62e458fae0e8329536fe2e3d2eeb3f695a548b46d5b3f44398c3406f215c6" => :high_sierra
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
