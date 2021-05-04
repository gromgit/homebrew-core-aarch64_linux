require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.2.11.tgz"
  sha256 "a8d09a7d2392ef7fbd8c912657731d84256518cd0621c303819b2a362ab1bb9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c1a1ea1c122a93dc91dca75dfdd9a06aaab8f0e2a18d11df66191947f470652"
    sha256 cellar: :any_skip_relocation, big_sur:       "060eadff130c0eee911c72ba497b2225cc4f1515624e69d70465e96bc63acceb"
    sha256 cellar: :any_skip_relocation, catalina:      "060eadff130c0eee911c72ba497b2225cc4f1515624e69d70465e96bc63acceb"
    sha256 cellar: :any_skip_relocation, mojave:        "060eadff130c0eee911c72ba497b2225cc4f1515624e69d70465e96bc63acceb"
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
