require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.0.8.tgz"
  sha256 "9a5f6b22826098b9455b649a461bb6c5ff9e20492e435d130a77b728751a4fd4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "619ebea018ac1f6a9707d321247f996d1a0b1a9951953fc47a5154f2803d7ebc" => :catalina
    sha256 "0d128cc6024d43ab0402e4fdf2ad1fdc9d470705e90d81b8d384dc5d19f616b7" => :mojave
    sha256 "dc6f793ecd623dab853d0c4beaee987be80b5e3190a5427169133d826db4dfe6" => :high_sierra
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
