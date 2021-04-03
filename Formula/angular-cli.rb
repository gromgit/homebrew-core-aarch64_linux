require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.2.7.tgz"
  sha256 "91df59a3dc7c9fd943b01ea8ff23864df1f75c31d4efc59579e2ca9c1291ae8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f2049afd06a06be723fd073d81edb3a3c53da740b7b0d3230fee4c8b6f77c644"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c0b60599f01d652373dffff755d5c77e7a0a36052ceed70b39f85434dcfa069"
    sha256 cellar: :any_skip_relocation, catalina:      "c8ca6874da2cfd4c95591f64f174a913ee2f8ae1bbf3eed263f78242b295d08b"
    sha256 cellar: :any_skip_relocation, mojave:        "b3b13c4f24e15b226d1baf981765d6e328d946f6437a188419c73bca067c174c"
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
