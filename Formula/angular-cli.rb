require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.2.2.tgz"
  sha256 "9c77c1297a7edbf2f95660fd84235777806108dc42ab3ba4beee14345fd32318"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c11df99bef70fe73f420ce1ed75d81ed0b742af35cd4b23748f4328c497e6f57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c11df99bef70fe73f420ce1ed75d81ed0b742af35cd4b23748f4328c497e6f57"
    sha256 cellar: :any_skip_relocation, monterey:       "01b0a35a8cf01282f48e66364b039744cccf7ad842165573bd8e52677c051b10"
    sha256 cellar: :any_skip_relocation, big_sur:        "01b0a35a8cf01282f48e66364b039744cccf7ad842165573bd8e52677c051b10"
    sha256 cellar: :any_skip_relocation, catalina:       "01b0a35a8cf01282f48e66364b039744cccf7ad842165573bd8e52677c051b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c11df99bef70fe73f420ce1ed75d81ed0b742af35cd4b23748f4328c497e6f57"
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
