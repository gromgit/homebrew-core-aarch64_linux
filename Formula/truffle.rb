require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.4.1.tgz"
  sha256 "b00866f5b331aae5430907db5e828d9017bdb52926effe5873e8b323c30940ac"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "c222cb345095f94e4a2a87bbdcb17adaf99914e6f7e1e1eac3ab2988bc0c33ee"
    sha256 big_sur:       "09139b8e9addd5846f9270c3719d9773b8f2c74222ef79374353b7c50cfe514a"
    sha256 catalina:      "024d03b9809184e0cc647f847e5c724c41a6745f68483e69818573751162e3a4"
    sha256 mojave:        "99142e380892f6efeb77f06a25afda6d22f574e4f305b3da93c2804d664eaec2"
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
