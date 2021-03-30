require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.2.6.tgz"
  sha256 "da75a9b51489d293942e891ce74aad386c9f211ad11f03361e2dc270de1fcce7"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "7cfbe7af0052f281b1bcdd395c5852663e42f3d2efd1fa71b26c345205e70464"
    sha256 big_sur:       "b54bac419bf9ca66474027df690bda2fe6d036a83e470cd2a05254bc1809716d"
    sha256 catalina:      "0e0482b9a2d88f5055e62d83a64f9ea6e1adbf2bb50bcae64b4e3e99dfb06e01"
    sha256 mojave:        "9749f3cb2a265117f13027b1ecda57576c8cee36fcb9dfe3e474acbcd2a0e311"
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
