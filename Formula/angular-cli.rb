require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.2.1.tgz"
  sha256 "6745fa1661497dff03222796846a75d4acc7837cc564e7c864c1e70406a6af9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b81dc1736d224a183762a841df62e1a74ed024f751d7698f85c373919d295e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "cabfb1a762965f45b7069bb82f855e19271c5aee64006d09cf06fbce5f15dd58"
    sha256 cellar: :any_skip_relocation, catalina:      "e0c0b3527104c8d77779503fabb116dd5d6427b4807ad9af4a1807f955728489"
    sha256 cellar: :any_skip_relocation, mojave:        "91bdd1fd0f7386e3028cc667aa72fc381d85ea8164434bd571f8abbb4438db2b"
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
