require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.46.tgz"
  sha256 "953867b4ddebee20d2ecae6e84fed9d32bc435bde8c38c7550eac4573ffe3e55"

  bottle do
    sha256 "bd4c3947bd8f9f994ed3bf1b7525dc1a8dd95d3ae586aaa116f62d9fb3447bbb" => :catalina
    sha256 "612c04d83da5782446b4503ae2addd1907d73d076eac4c921c92b9b424e2d59f" => :mojave
    sha256 "49cc9ab9039d914e31803514a953e288d95b00e21d5d903ec5b86523c76ee66e" => :high_sierra
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
