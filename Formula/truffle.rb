require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.2.4.tgz"
  sha256 "8ccf0a988758ab308f7c71f82211dd517852504d4cc4319915d0dc364abf073b"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "70f8339e07301b2565c2a236ccb55a77e5e904346aef897089f2889b158cea83"
    sha256 big_sur:       "f29b36461ceebbb0618e7c85a8d88e71c30094377f1e136a05428634aa2c44ef"
    sha256 catalina:      "2b79ae54282271b8bda33c6782ad703325938eba4571e7f19f0333e80812474e"
    sha256 mojave:        "dc1a77ae0f0780b8c2e74db3b57a63616046092c27d7874e294c628a7bfebf1e"
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
