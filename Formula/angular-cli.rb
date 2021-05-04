require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.2.11.tgz"
  sha256 "a8d09a7d2392ef7fbd8c912657731d84256518cd0621c303819b2a362ab1bb9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d8dc6960b5543f68c4f724923e7c0924defd1f0db51a7499724fe0cbce7ad6ff"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca0fd5690a46d5b9980706149d8c7c7b28683f17e0397ccbbe66b304071e78e9"
    sha256 cellar: :any_skip_relocation, catalina:      "ca0fd5690a46d5b9980706149d8c7c7b28683f17e0397ccbbe66b304071e78e9"
    sha256 cellar: :any_skip_relocation, mojave:        "ca0fd5690a46d5b9980706149d8c7c7b28683f17e0397ccbbe66b304071e78e9"
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
