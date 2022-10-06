require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.2.5.tgz"
  sha256 "b02e69f68d1188146b0e52aedb9392803a33ccdb073fee5ab9cdbf6cee3a86c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc73f7809b8a262c4c95cd372aa101ac5bbb43ca2c196e13eb3f5e926101e10e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc73f7809b8a262c4c95cd372aa101ac5bbb43ca2c196e13eb3f5e926101e10e"
    sha256 cellar: :any_skip_relocation, monterey:       "b72a764b5e2947cbd1d9ed3fc5ab72675e7db39d998f4e14a0a808a7a902b9d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b72a764b5e2947cbd1d9ed3fc5ab72675e7db39d998f4e14a0a808a7a902b9d4"
    sha256 cellar: :any_skip_relocation, catalina:       "b72a764b5e2947cbd1d9ed3fc5ab72675e7db39d998f4e14a0a808a7a902b9d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc73f7809b8a262c4c95cd372aa101ac5bbb43ca2c196e13eb3f5e926101e10e"
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
