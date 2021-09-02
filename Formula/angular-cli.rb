require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.2.4.tgz"
  sha256 "e553800b6560eb9ed8c2c9e5aab294b147a254f0a1b7f386eed04d9e5411fe34"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "75173a951d2cec71f1f71d670bbfbc79d8cc5009d4281b09d6faec214de590bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "2fde763fdc92548b4989e2eb616e490df08bdc389a8b53f70e843f0e6121db87"
    sha256 cellar: :any_skip_relocation, catalina:      "2fde763fdc92548b4989e2eb616e490df08bdc389a8b53f70e843f0e6121db87"
    sha256 cellar: :any_skip_relocation, mojave:        "2fde763fdc92548b4989e2eb616e490df08bdc389a8b53f70e843f0e6121db87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75173a951d2cec71f1f71d670bbfbc79d8cc5009d4281b09d6faec214de590bc"
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
