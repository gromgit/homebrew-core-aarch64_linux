require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.3.13.tgz"
  sha256 "7e22d8d947008ddc326fdb9c9d30a85fb748c92ff39a4996c3a7a4f5c5d18743"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "d94c9ec49b979c868b660af7190a0eac986921fc92be0c6cf0ea3a352d300098"
    sha256 big_sur:       "c632535a837bc429389b9d41a58be4121f85ff333bc27b394d393306b3612453"
    sha256 catalina:      "4070875c9df6e2d15efc7c74e94f52a017488399a30bd5909a770a3b244ee39a"
    sha256 mojave:        "b66e42ca3a4f897e6ea92e2bc4733f9f4622b62d4048f86f30c3837f151b587a"
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
