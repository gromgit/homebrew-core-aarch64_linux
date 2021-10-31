require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.2.12.tgz"
  sha256 "4201ec9fabf0a06f870e7409c1a23beaea2a2f74c81f5c8c2a7a0534e92f3099"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5867f79cb18c8d46f8670bd2882d6df49e506a0b367f0169e4445eb5af9ee666"
    sha256 cellar: :any_skip_relocation, big_sur:       "312bfa830af6f0fc40366ac7b77a41959efbf5a2f34f8aee18abccf40c2d147a"
    sha256 cellar: :any_skip_relocation, catalina:      "312bfa830af6f0fc40366ac7b77a41959efbf5a2f34f8aee18abccf40c2d147a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5867f79cb18c8d46f8670bd2882d6df49e506a0b367f0169e4445eb5af9ee666"
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
