require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.0.6.tgz"
  sha256 "7129281ad4994198fb7fdd37ef3b7684b7bb17bf9b835d99d60ca0774c4480b6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "979ef00bdb0c5f87f9f16d5478c7d957cb40acf2a91e4d8cdf6f3ae392d87881" => :catalina
    sha256 "124422c8231bffb1411c56b5d4855278d4385dab73dd9778c2f4f57d18166fe6" => :mojave
    sha256 "3ce643d0af9796f8d0e9a245580b2fff0375dfe25530ae9f664e911a8dd1ecbb" => :high_sierra
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
