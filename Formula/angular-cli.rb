require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.0.0.tgz"
  sha256 "113b7edfcbafc97bb49c2b8a65867b69005de0182bdbb16573537a5e86626efe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d905c8b4bcd496fea203f21db20aee14bb3fef9ec8710a7ef81ba32c1b63dbe2"
    sha256 cellar: :any_skip_relocation, big_sur:       "bc90d47cf1f6dfe757ff0c8b3c13fd3d43db5483c9c38715e5949b5e806a8f21"
    sha256 cellar: :any_skip_relocation, catalina:      "bc90d47cf1f6dfe757ff0c8b3c13fd3d43db5483c9c38715e5949b5e806a8f21"
    sha256 cellar: :any_skip_relocation, mojave:        "bc90d47cf1f6dfe757ff0c8b3c13fd3d43db5483c9c38715e5949b5e806a8f21"
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
