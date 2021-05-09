require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.3.5.tgz"
  sha256 "814da84b3d520ce508db34fa85d6673bc1683a7eb40d1c44b5a6de766dd4817a"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "19f88ac63977c5944c34a093fd76be9eef1bca5fc381ddb1fff22b44c6a8d78b"
    sha256 big_sur:       "c66738affb0e9ad09c6aa998f216126aee666484f2c2fc4d2c64a41c801f602e"
    sha256 catalina:      "15161fbf118309f1ec0a549135a4708f316f3798c4da69d614d306fb5b01acf0"
    sha256 mojave:        "2a37d932df68e2424a1755db249bbf912030a68e29e3f7939936ab9da863a93a"
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
