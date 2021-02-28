require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.2.0.tgz"
  sha256 "8e89423cbb057316b1ce17867501a52c2d0d7c9a06a20f09d820bce0fbb16fbf"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "71c3ce6db495c2ac0a44e951fada81fde9861582e5f34633def0d4902a4a800a"
    sha256 big_sur:       "b363d740f40bf0e69bb6a126db50949fda74ed8142de958ef6171fb1e7ae14a5"
    sha256 catalina:      "4c50fd952001599ad547683314a40102aa68fa74c9ef69e17b13dd5b57b1a61e"
    sha256 mojave:        "9fd8a77cc64826c12e819066a6847de192bac20828254446af0ef3efdffa9814"
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
