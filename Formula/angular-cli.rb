require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.0.0.tgz"
  sha256 "f47449cf2a36acec44de4e8baafd6b27f72ab69f227f69ad5722bc85a9ee0d1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c95683bfb9952af7408b3270e368ce09de7b434aa43cc1e5f5a276484fc19b2a"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf104a2639c2f5e1cba23bf7a25c4414ad23fe04822fc5a26c9aacacc77b3f29"
    sha256 cellar: :any_skip_relocation, catalina:      "bf104a2639c2f5e1cba23bf7a25c4414ad23fe04822fc5a26c9aacacc77b3f29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c95683bfb9952af7408b3270e368ce09de7b434aa43cc1e5f5a276484fc19b2a"
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
