require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.2.7.tgz"
  sha256 "c6df21286bde837046a6d78eae46f80261fb73d482d33247e2e771acd5f8dc4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e57caf570b79cfbebaa4498877c6cedaf1d4a0ae33ac7f785a432f450798abb"
    sha256 cellar: :any_skip_relocation, big_sur:       "32981960a688f8daa8b636a4e27e63f6091e2d9c6b48ec88a6751a36b5732538"
    sha256 cellar: :any_skip_relocation, catalina:      "32981960a688f8daa8b636a4e27e63f6091e2d9c6b48ec88a6751a36b5732538"
    sha256 cellar: :any_skip_relocation, mojave:        "32981960a688f8daa8b636a4e27e63f6091e2d9c6b48ec88a6751a36b5732538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e57caf570b79cfbebaa4498877c6cedaf1d4a0ae33ac7f785a432f450798abb"
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
