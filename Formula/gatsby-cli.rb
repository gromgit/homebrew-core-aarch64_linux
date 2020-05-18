require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.24.tgz"
  sha256 "0d036b76f72cff6a24b3e8ec4c788e2b9a2c2b63f613f92a4b2fc01b9f00b364"

  bottle do
    sha256 "ba4abad823d9a68db6c550442653c3a4e91ee13d73c7f5f6b742ae9bbfb5de7d" => :catalina
    sha256 "3554919259258e53882424d1362c3b350e729758f038ce20b106d0995aaf6db2" => :mojave
    sha256 "ce93ec07515ea23096809b78b7acf069441198267f4bc29cb9ba9f267342a4b4" => :high_sierra
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
