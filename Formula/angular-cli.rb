require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.1.4.tgz"
  sha256 "1099a775fef08fb300de97ccf02aa71b53a057c882a69c62aec0871b7b6d7d5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbf2d40d828629fc1cdf4e1442d55e9b5c55036fe8788c952efea9ab76873eeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbf2d40d828629fc1cdf4e1442d55e9b5c55036fe8788c952efea9ab76873eeb"
    sha256 cellar: :any_skip_relocation, monterey:       "5f398c8498b1bd2611ff6ed550aae5b4f44078c8dc55d26eb9d289583fc0f38a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f398c8498b1bd2611ff6ed550aae5b4f44078c8dc55d26eb9d289583fc0f38a"
    sha256 cellar: :any_skip_relocation, catalina:       "5f398c8498b1bd2611ff6ed550aae5b4f44078c8dc55d26eb9d289583fc0f38a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbf2d40d828629fc1cdf4e1442d55e9b5c55036fe8788c952efea9ab76873eeb"
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
