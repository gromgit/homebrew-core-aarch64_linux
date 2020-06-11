require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.45.tgz"
  sha256 "cbb0d73f31bd84defc5f1ed1b04a1fb665b551e83395958772f4ac61be72dffa"

  bottle do
    sha256 "ab2bf4d240b0c344874f29020fb42dfc44ec130d55e1b4cc6ea40a774297cf1a" => :catalina
    sha256 "f12dc08c1c352b6fdb10cbf9ecffa8076d3ebd76a2459010470a27d008de1837" => :mojave
    sha256 "e897bedd3985380b8bb7400e1a6b184d000017a50d43f14983d7cae1b37d2247" => :high_sierra
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
