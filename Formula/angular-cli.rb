require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.1.0.tgz"
  sha256 "9b34d71a00d849c035ee0ef05a3fa13310de5d2e0a36b4491f940990868104bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f755f4ef5c2960dabf41f55c757bf51a3b888b6c003b44c8509dbb8c5d29b35b"
    sha256 cellar: :any_skip_relocation, big_sur:       "0fee2bdc30bf37e1504563ef41221d5ae57a14a516bff015f95c5d00ec26cbbf"
    sha256 cellar: :any_skip_relocation, catalina:      "0fee2bdc30bf37e1504563ef41221d5ae57a14a516bff015f95c5d00ec26cbbf"
    sha256 cellar: :any_skip_relocation, mojave:        "0fee2bdc30bf37e1504563ef41221d5ae57a14a516bff015f95c5d00ec26cbbf"
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
