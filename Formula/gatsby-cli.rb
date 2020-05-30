require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.37.tgz"
  sha256 "5b778bdc8f365931497daa758363a4ea8b26451ae1626bbe09f9265271ea2a59"

  bottle do
    sha256 "996e44dc1158b0edae8cf5cd163b8b3cc88c17059633b88baa4cf4848614cd67" => :catalina
    sha256 "f971a050bf2797c7d990f449f6593539d5ce59a465ca8bb81f26f1a4386d78cd" => :mojave
    sha256 "23bb972f0736fcc5fe4633ce9533e52d0a2232a9658d3e0d5530895660423bed" => :high_sierra
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
