require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.11.11.tgz"
  sha256 "a61008e7200773f2c05bebbd769b8e8d899b9c5a2d5fd93a7161561baed002b7"

  bottle do
    sha256 "a7a99fc9cf662e8ad17f37237cc16b51c2a66b364b225d4a2d16aa836d5bcf33" => :catalina
    sha256 "807a8513081b0227da735372e4cc052de96f3576f0e2689b1efdb2de62f7da0c" => :mojave
    sha256 "39e6a5440983323fd61b76e5637e4f0abd749c518182734146e7137102425b08" => :high_sierra
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
