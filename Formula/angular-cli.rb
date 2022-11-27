require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.3.5.tgz"
  sha256 "35e2d8755329414e6c8fa57e4d2f5af476f2890fe3ec1a76454d3c4d5657d760"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea0224c1d1bb3879b6c799e20a622330e2e8602c388369956eac8fbbb940f8c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea0224c1d1bb3879b6c799e20a622330e2e8602c388369956eac8fbbb940f8c7"
    sha256 cellar: :any_skip_relocation, monterey:       "699880d1613018b5c83e2b4797b20c669a74cbdb8a11f0a779696b77828162e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "699880d1613018b5c83e2b4797b20c669a74cbdb8a11f0a779696b77828162e8"
    sha256 cellar: :any_skip_relocation, catalina:       "699880d1613018b5c83e2b4797b20c669a74cbdb8a11f0a779696b77828162e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea0224c1d1bb3879b6c799e20a622330e2e8602c388369956eac8fbbb940f8c7"
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
