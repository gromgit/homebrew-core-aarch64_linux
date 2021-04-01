require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.3.0.tgz"
  sha256 "f5fea28a4d55beac04d35040018b7970e12a35a514647c50fd355780cf9446c3"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "d3cdc691032335f5cc15878c9be908db2408e3017550a716d85232f401afab83"
    sha256 big_sur:       "e41adf114a228d11a79dc8245d8acd5f5dcf2357649f759d129aa3728ca9d4ba"
    sha256 catalina:      "805a10c1c6a8d5ff6a0d6590d3e403f311a0c73818e90c98ceb0e327d8d0403d"
    sha256 mojave:        "84f615b314ef0f5a961f1f002250a4d47ba9841fe254150f61d7424815f06c96"
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
