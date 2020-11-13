require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.0.1.tgz"
  sha256 "836291e7e1b804ede40730b8665bc030d7dc43148d6b43f1d79d0b0c0e0d8cf2"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2a7e968e78e18a24b8ddc7a0ebe0629f0ef1f500597c1c0acef3823798cd7a8a" => :catalina
    sha256 "0f9f5f57e77a1e8f811809a198f3b141a80384258297fee7a42460e7923c1083" => :mojave
    sha256 "2543a8c5d3188a1a7ad962cf4f467f9ae39eccee35b476e4057335294ea9e098" => :high_sierra
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
