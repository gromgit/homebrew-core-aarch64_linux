require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.8.0.tgz"
  sha256 "06d4242f85e6291ce3a7798d171f3642d54320d5995731b6cdedb51e80eaee7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c2e1002279f6209d0dcf94d090b4e6f86725583d98107ab0b426c896fa3684c"
    sha256 cellar: :any_skip_relocation, big_sur:       "0268628ac12047c5de7625fb26169f11d00eb116e01e8c5c27c167120d487a6b"
    sha256 cellar: :any_skip_relocation, catalina:      "0268628ac12047c5de7625fb26169f11d00eb116e01e8c5c27c167120d487a6b"
    sha256 cellar: :any_skip_relocation, mojave:        "0268628ac12047c5de7625fb26169f11d00eb116e01e8c5c27c167120d487a6b"
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
