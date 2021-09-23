require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.2.7.tgz"
  sha256 "c6df21286bde837046a6d78eae46f80261fb73d482d33247e2e771acd5f8dc4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "007d7b88519047482f1650a2629e929f2042ef5aa4ea82b34a6da95e4a8f17ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "aa83aae04a616c2ae7381e4939990495d7a60d61975c33e43132d6e5584602af"
    sha256 cellar: :any_skip_relocation, catalina:      "aa83aae04a616c2ae7381e4939990495d7a60d61975c33e43132d6e5584602af"
    sha256 cellar: :any_skip_relocation, mojave:        "aa83aae04a616c2ae7381e4939990495d7a60d61975c33e43132d6e5584602af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "007d7b88519047482f1650a2629e929f2042ef5aa4ea82b34a6da95e4a8f17ed"
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
