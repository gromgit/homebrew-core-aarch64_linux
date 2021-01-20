require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.18.0.tgz"
  sha256 "6889094114512d15220ce75d257df54eb36fcd156cca3777b05e41f3fa510724"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "383ec073af95af04cde8b52682034739095804e9297935b52fb5494313973969" => :big_sur
    sha256 "6cdd951dd5a6734196e2b54b7ae222820903e48bc76def73dd840f091479d59c" => :arm64_big_sur
    sha256 "b862e00713f24de263ba5b1ce051cd22e602cce031d351c690601a181e661d63" => :catalina
    sha256 "9abd4cf47e542a3f42fec4053b95e8941b412be9e9eea13c93e640c07fec3227" => :mojave
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
