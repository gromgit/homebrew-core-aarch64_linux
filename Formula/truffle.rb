require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.1.65.tgz"
  sha256 "60e5ebaf5a24fb9b2642b3d69ac6cbd690b3742ff7d9f7a0598c87e1282f82b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ed2e0a343feaea348f271d993955c51864d256131930eba47385212f7006444b"
    sha256 cellar: :any_skip_relocation, big_sur:       "32149f53ddddd471e2001a352bc8b409ef914d7a622f169114111b6035e261bf"
    sha256 cellar: :any_skip_relocation, catalina:      "fa49884ba164c557202ea79fb7289cb7e62f2c97b56ab08657bee895e02c1e63"
    sha256 cellar: :any_skip_relocation, mojave:        "5eabbf8bc14624d128edc27831bdf45b0d3cf52aad784768126c53922cf09bbd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"truffle", "init"
    system bin/"truffle", "compile"
    system bin/"truffle", "test"
  end
end
