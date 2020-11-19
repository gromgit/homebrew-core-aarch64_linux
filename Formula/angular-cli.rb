require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.0.2.tgz"
  sha256 "daaec337289a3d7f5cbd16abf47a4173810eadd93fc6648ba064d3d93cf40b28"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d400b6415397a10de6a91ac8aaaf5a092cb2959ec4358c8181bf5852a19e6fe9" => :big_sur
    sha256 "5943d987cf2ccc780811a624248be237efbe3fe1183e9762730ce7f906e73d75" => :catalina
    sha256 "672b39e68a9b7ce04f43ff26cab499dc28081d7f23c878b2d85f4124a2c6dca4" => :mojave
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
