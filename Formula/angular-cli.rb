require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.2.8.tgz"
  sha256 "aa866ac857be14e9a0681f1addd2d8e09c31f07a71ce694212d1e0be2e5459e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f188b8f88e1eb0c59dd9280fe949a09da8b9e309b1df876cb94b27a47f5d4705"
    sha256 cellar: :any_skip_relocation, big_sur:       "96dcc3f9cb4e1c85319f9e8d966bde709e7a871f08b49d446dff6275d34f9ea6"
    sha256 cellar: :any_skip_relocation, catalina:      "cdf6bfdb701c2e6b4907d2cd793257c04e1fd2238ddc8b900166d3b027a01934"
    sha256 cellar: :any_skip_relocation, mojave:        "b0ab7139431e4d7963fc465c9573a023f78fb2662f3b6f00a335ad89784c4b7e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
